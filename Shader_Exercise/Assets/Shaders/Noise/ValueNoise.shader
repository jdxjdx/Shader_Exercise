Shader "Shader_Exercise/ValueNoise"
{
    Properties
    {
	    _GridSize ("SparkGridSize", float) = 30
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define USING_VALUE_NOISE 

            #include "UnityCG.cginc"
            #include "../ShaderLibs/Noise.cginc"

            float _GridSize;
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
                fixed col = VNoise(i.uv * _GridSize);
                return fixed4(col,col,col,1);
            }
            
            ENDCG
        }
    }
}
