Shader "Shader_Exercise/LitFur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Noise ("Noise Tex", 2D) = "white" {}
        
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Specular ("Specular", Color) = (1, 1, 1, 1)
        _Shininess ("Shininess", Range(0.01, 256.0)) = 8.0
        
        _FurLength ("FurLength", float) = 0
        _FurRadius ("FurRadius", float) = 0
        _FurThinness ("FurThinness", float) = 1
        _Timing ("Timing", float) = 1
        
        _OcclusionPower ("Occlusion Power", float) = 1
        _OcclusionColor("Occlusion Color", Color) = (0.0, 0.0, 0.0, 0)
        
        _ForceGlobal ("Force Global", Vector) = (0, 0, 0, 0)
        _ForceLocal ("Force Local", Vector) = (0, 0, 0, 0)
    }
    category
    {
       Tags{"LightMode"="ForwardBase" "RenderType" = "Transparent" "IgnoreProjector" = "True" "Queue" = "Transparent"}
        
       Blend SrcAlpha OneMinusSrcAlpha
        
       SubShader
        {
            pass
            {
                CGPROGRAM//基础渲染层 防止镂空
                #pragma vertex vert_base
                #pragma fragment frag_base
                #define FURSTEP 0.0 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.05 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.1 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.15 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.2 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.25 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.3 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.35 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.4 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.45 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.5 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.55 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.6 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.65 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.7 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.75 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.8 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.85 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.9 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 0.95 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 1 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 1.05 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 1.1 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 1.15 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }
            pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #define FURSTEP 1.2 //定义宏
                #include "../ShaderLibs/FurShaderInclude.cginc"
                ENDCG
            }

        }
    }
}
