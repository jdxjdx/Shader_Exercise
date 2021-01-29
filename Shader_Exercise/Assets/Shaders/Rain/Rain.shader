Shader "Shader_Exercise/Rain"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed ("Speed", float) = 10
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "../ShaderLibs/Hash.cginc"

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
            
            sampler2D _MainTex; float4 _MainTex_ST;
            float _Speed;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float speed = _Time * _Speed;
                float3 emissive = 1 - frac(speed);
                float3 emissive2 = 1 - frac(speed + 0.5);//偏移一点时间，让涟漪扩散时间错开
                float3 texColor = tex2D(_MainTex,TRANSFORM_TEX(i.uv, _MainTex)).rgb;
                float3 texColor2 = tex2D(_MainTex,TRANSFORM_TEX(i.uv + float2(0.5,0.5), _MainTex)).rgb;
                float maskColor = step(0.000001, texColor.r) * saturate(1 - abs(emissive.r - texColor.r - 0.05) * 20);
                float maskColor2 = step(0.000001, texColor2.r) * saturate(1 - abs(emissive2.r - texColor2.r - 0.05) * 20);
                float maskSwitch = abs(sin((_Time * 0.5)));//两张图交替淡入
                float finalColor = lerp(maskColor2, maskColor, maskSwitch);
                return float4(finalColor,finalColor,finalColor,1);
            }
            ENDCG
        }
    }
}
