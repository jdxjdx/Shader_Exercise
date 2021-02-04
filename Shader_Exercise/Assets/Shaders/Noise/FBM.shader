Shader "Shader_Exercise/FBM"
{
    Properties
    {
        _NoiseTex ("_NoiseTex", 2D) = "white" {}
	    _GridSize ("SparkGridSize", float) = 30
        
        [Header(Option)]
        [Enum(PERLIN, 0, VALUE, 1, SIMPLEX, 2)]_NoiseType ("NoiseType", Int) = 0
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #include "../ShaderLibs/FBM.cginc"
            float _GridSize;
            float _NoiseType;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed col = 0;
                
                switch(_NoiseType) {
                    case 0:
                        col = FBMP(i.uv * _GridSize);
                        break;
                    case 1:
                        col = FBMV(i.uv * _GridSize);
                        break;
                    case 2:
                        col = FBMS(i.uv * _GridSize);
                        break;
                    default:
                        col = FBM(i.uv * _GridSize);
                        break;
                }
                
                return fixed4(col,col,col,1);
            }
            
            ENDCG
        }
    }
}
