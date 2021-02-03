Shader "Shader_Exercise/DirDissolve"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DissTex("Dissolve Texture", 2D) = "white"{}
        
        _DissolveDirection("Dissolve Direction", Vector) = (0,1,0)

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
                float4 worldFactor : TEXCOORD1;
            };

            sampler2D _MainTex;
			sampler2D _DissTex;
            float4 _MainTex_ST;
			float4 _DissTex_ST;

            float3 _DissolveDirection;
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
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
                float3 center = float3(unity_ObjectToWorld[0].w, unity_ObjectToWorld[1].w, unity_ObjectToWorld[2].w);//计算物体中心点
                //以下都可以
                //float3 center = float3(unity_ObjectToWorld._m03, unity_ObjectToWorld._m13, unity_ObjectToWorld._m23);
                //float3 center = mul(unity_ObjectToWorld , float(0,0,0,1)).xyz;
                //float3 center = unity_ObjectToWorld._14_24_34；
                
                float3 posDir = worldPos.rgb - center;
                float worldFactor = dot(normalize(_DissolveDirection), posDir);//根据当前顶点位置计算在消融方向上的投影
                o.worldFactor = worldFactor;//==这么做_Clip初始值就不固定了
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed dissove = tex2D(_DissTex, i.uv.zw).r;
				dissove = dissove + i.worldFactor * _WorldSpaceScale;
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
