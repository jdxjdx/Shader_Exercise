Shader "Shader_Exercise/UVDissolve"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DissTex("Dissolve Texture", 2D) = "white"{}
        
        _DissolveCenterUV("Dissolve Center UV", Vector) = (0,1,0)
        _WorldSpaceScale("World Space Dissolve Factor", float) = 0.1
        
        _EdgeWidth("Edge Wdith", Range(0, 1)) = 0
        _Smoothness("Smoothness", Range(0.001, 1)) = 0.2
        
        [HDR]_DlvEdgeColor("Dissolve Edge Color", Color) = (0.0, 0.0, 0.0, 0)
        
        _Clip("Clip", float) = 1
    }
    SubShader
    {
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
				float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
			sampler2D _DissTex;
            float4 _MainTex_ST;
			float4 _DissTex_ST;

            float2 _DissolveCenterUV;
            fixed _Clip;
            fixed _WorldSpaceScale;

            float4 _DlvEdgeColor;
			float _EdgeWidth;
            fixed _Smoothness;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.uv, _DissTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed dissove = tex2D(_DissTex, i.uv.zw).r;
             	float dist = distance(_DissolveCenterUV, i.uv.xy);//计算距离设置中心点的距离
				dissove = dissove + dist * _WorldSpaceScale;//根据距离和噪声纹理计算
				float dissolve_alpha = step(_Clip, dissove);
				clip(dissolve_alpha - 0.5);
                float colorLerp = smoothstep(0, _Smoothness, saturate(_Clip - dissove + _EdgeWidth));
                col.rgb = lerp(col.rgb, _DlvEdgeColor, colorLerp);
                return col;
            }
            ENDCG
        }
    }
}
