//
//  MetalTriangleDemoViewController.swift
//  someDemo
//
//  Created by sylar on 2025/6/24.
//

import Foundation
import MetalKit

class MetalTriangleDemoViewController : SomeDemoBaseViewController {
    let mtkView : MTKView = MTKView.init()
    var pipelineState : MTLRenderPipelineState!
    var commandQueue : MTLCommandQueue!
    var vertices : MTLBuffer!
    var texture : MTLTexture!
    var viewportSize : CGSize = CGSize.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mtkView.frame = self.view.bounds
        mtkView.device = MTLCreateSystemDefaultDevice()
        self.view = mtkView
        mtkView.delegate = self
        
        // 添加这些配置
        mtkView.framebufferOnly = false
        mtkView.clearColor = MTLClearColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        mtkView.enableSetNeedsDisplay = true
        mtkView.isPaused = false
        self.viewportSize = self.view.frame.size
        setupPipeline()
        //默认全拉满画满
        //        setupVertex()
        setupTexture()
    }
    
    func setupPipeline(){
        let defaultLibrary = self.mtkView.device?.makeDefaultLibrary()
        let vertexFunc = defaultLibrary?.makeFunction(name: "vertexShader")
        let fragmentFunc = defaultLibrary?.makeFunction(name: "samplingShader")
        
        self.commandQueue = self.mtkView.device?.makeCommandQueue()
        
        let pipelineStateDes = MTLRenderPipelineDescriptor.init()
        pipelineStateDes.vertexFunction = vertexFunc
        pipelineStateDes.fragmentFunction = fragmentFunc
        pipelineStateDes.colorAttachments[0].pixelFormat = self.mtkView.colorPixelFormat
        do {
            self.pipelineState = try self.mtkView.device?.makeRenderPipelineState(descriptor: pipelineStateDes )
        }catch {
            fatalError("Can't create PipelineState")
        }
    }
    
    func setupVertex(){
        let standardImageVertices: [Float] = [-1.0, 1.0, 1.0, 1.0, -1.0, -1.0, 1.0, -1.0]
        
        self.vertices = self.mtkView.device?.makeBuffer(bytes: standardImageVertices, length: standardImageVertices.count * MemoryLayout<Float>.size, options: [])
    }
    
    func setupTexture () {
        let textureLoader = MTKTextureLoader(device: self.mtkView.device!)
        do {
            self.texture =  try textureLoader.newTexture(cgImage: (UIImage(named: "metal_texture.jpg")?.cgImage)!)
            mtkView.drawableSize = CGSizeMake(CGFloat(self.texture.width), CGFloat(self.texture.height))
            
            //根据图片宽高等比显示
            let imageAspect = Float(texture.width) / Float(texture.height)
            let screenAspect = Float(self.view.frame.size.width) / Float(self.view.frame.size.height)
            
            // 计算实际显示的矩形大小
            var rectWidth: Float = 1.0
            var rectHeight: Float = 1.0
            
            if imageAspect > screenAspect {
                // 图片比屏幕更宽，以宽度为基准
                rectWidth = 1.0
                rectHeight = screenAspect / imageAspect
            } else {
                // 图片比屏幕更窄，以高度为基准
                rectHeight = 1.0
                rectWidth = imageAspect / screenAspect
            }
            let standardImageVertices: [SIMD2<Float>] = [
                SIMD2<Float>(-rectWidth, rectHeight),   // 左上
                SIMD2<Float>(rectWidth, rectHeight),    // 右上
                SIMD2<Float>(-rectWidth, -rectHeight),   // 左下
                SIMD2<Float>(rectWidth, -rectHeight),   // 右下
                
            ]
            self.vertices = self.mtkView.device?.makeBuffer(
                bytes: standardImageVertices,
                length: standardImageVertices.count * MemoryLayout<SIMD2<Float>>.size,
                options: []
            )
        } catch {
            fatalError("Can't Load Image")
        }
        
    }
    
}

extension MetalTriangleDemoViewController : MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.viewportSize = size
    }
    
    func draw(in view: MTKView) {
        let commandBuffer = self.commandQueue.makeCommandBuffer()
        if let rederPassDescriptor = view.currentRenderPassDescriptor {
            rederPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
            let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: rederPassDescriptor)
            renderEncoder?.setRenderPipelineState(self.pipelineState)
            renderEncoder?.setVertexBuffer(self.vertices, offset: 0, index: 0)
            
            let textureCoord : [Float] = [0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0]
            
            let textureBuffer = self.mtkView.device?.makeBuffer(bytes: textureCoord, length: textureCoord.count * MemoryLayout<Float>.size, options: [])
            renderEncoder?.setVertexBuffer(textureBuffer, offset: 0, index: 1)
            renderEncoder?.setFragmentTexture(self.texture, index: 0)
            renderEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
            renderEncoder?.endEncoding()
            commandBuffer?.present(view.currentDrawable!)
        }
        commandBuffer?.commit()
        
    }
}
