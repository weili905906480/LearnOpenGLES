//
//  TrianglesDemoController.m
//  LearnOpenGLES-01
//
//  Created by Lowell on 2020/5/5.
//  Copyright © 2020 zh2zh. All rights reserved.
//

#import "TrianglesDemoController.h"

@interface TrianglesDemoController ()
{
    // 定点缓存标识符
    GLuint vertexBufferID;
}

// GLKit 提供的用来渲染的类，这个类为我们封装了opengl中操作shader的一些操作
@property (strong, nonatomic) GLKBaseEffect *baseEffect;

@end

@implementation TrianglesDemoController

/////////////////////////////////////////////////////////////////
// 构造一个存储顶点的数据
typedef struct {
   GLKVector3  positionCoords;
}
SceneVertex;

/////////////////////////////////////////////////////////////////
// 初始化数据
static const SceneVertex vertices[] =
{
   {{-0.5f, -0.5f, 0.0}}, // lower left corner
   {{ 0.5f, -0.5f, 0.0}}, // lower right corner
   {{-0.5f,  0.5f, 0.0}}  // upper left corner
};


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //由于我们继承了GLKViewController，因此当前View是GLKView，
    //使用GLKView的好处是，它为我们封装了Op//engl如何将图像渲染到View上的过程
    GLKView *view = (GLKView *)self.view;
    
    // 初始化Context
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // 设置当前的Context
    [EAGLContext setCurrentContext:view.context];
    
    // 创建渲染类
    self.baseEffect = [[GLKBaseEffect alloc] init];
    // 设定渲染类使用的颜色，使用固定颜色
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
       1.0f, // Red
       1.0f, // Green
       1.0f, // Blue
       1.0f);// Alpha
    
    // 设定画布的背景颜色
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    // Generate, bind, and initialize contents of a buffer to be
    // stored in GPU memory
    // 执行树上介绍的6步操作，生成，绑定，初始化数据到缓存中，在实际应用中并不一定严格会这样操作，
    // 因为对于y音视频来说，我们不需要经常改变顶点坐标和纹理坐标，所有在性能上来说使用缓存的影响有限
    glGenBuffers(1,                // STEP 1
       &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
       vertexBufferID);
    glBufferData(                  // STEP 3
       GL_ARRAY_BUFFER,  // Initialize buffer contents
       sizeof(vertices), // Number of bytes to copy
       vertices,         // Address of bytes to copy
       GL_STATIC_DRAW);  // Hint: cache in GPU memory
}

// GLView的回调方法，这个方法会根据屏幕刷新率来调用，我们需要做的是在这个回调函数里更新我们的界面
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // 渲染类做一些准备工作
    [self.baseEffect prepareToDraw];
    
    // 清掉缓存
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Enable use of positions from bound vertex buffer
    glEnableVertexAttribArray(      // STEP 4
       GLKVertexAttribPosition);
       
    // 描叙如何使用缓存数据
    glVertexAttribPointer(          // STEP 5
       GLKVertexAttribPosition,
       3,                   // three components per vertex
       GL_FLOAT,            // data is floating point
       GL_FALSE,            // no fixed point scaling
       sizeof(SceneVertex), // no gaps in data
       NULL);               // NULL tells GPU to start at
                            // beginning of bound buffer
                                    
    // Draw triangles using the first three vertices in the
    // currently bound vertex buffer
    glDrawArrays(GL_TRIANGLES,      // STEP 6
       0,  // Start with first vertex in currently bound buffer
       3); // Use three vertices from currently bound buffer
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 当界面不可见时时需要销毁缓存
    // Make the view's context current
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
     
    // Delete buffers that aren't needed when view is unloaded
    if (0 != vertexBufferID)
    {
       glDeleteBuffers (1,          // STEP 7
                        &vertexBufferID);
       vertexBufferID = 0;
    }
    
    // Stop using the context created in -viewDidLoad
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
    
}


@end
