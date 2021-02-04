Shader "Shader_Exercise/SimplexNoise"
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
                fixed col = SNoise(i.uv * _GridSize) + 0.5;
                return fixed4(col,col,col,1);
            }
            
            ENDCG
        }
    }
}
