Shader "Shader_Exercise/2DSnow"
{
    Properties
    {
        _Size("Size", float) = 0.1
        _XSpeed("XSpeed", float) = 0.2
        _YSpeed("YSpeed", float) = 0.5
        _Layer("Layer", float) = 10
    }
    SubShader
    {
	    Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

        Pass
        {
            ZWrite Off
	        Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "../ShaderLibs/Hash.cginc"

            float _Size;
            float _XSpeed;
            float _YSpeed;
            float _Layer;

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
                fixed4 color = fixed4(0.0,0.0,0.0,0.0);

                for (fixed layer=0.;layer<_Layer;layer++)//多层 形成远近效果
                {
                    fixed2 uv = i.uv;
                    uv = uv * (2.0+layer);//透视视野变大效果
                    float xOffset = uv.y * (((Hash11(layer)*2-1.)*0.5+1.)*_XSpeed);//增加x轴移动
			        float yOffset = (_YSpeed*_Time.y);//y轴下落过程
                    uv += fixed2(xOffset,yOffset);//增加移动
                    float2 rgrid = Hash22(floor(uv)+(31.1759*layer));//计算每个格子的随机偏移
                    uv = frac(uv);//取小数部分
                    uv -= (rgrid*2-1.0) * 0.35;//增加随机偏移
                    uv -= 0.5;//(0,0)设置为中心
                    float module = length(uv);//取模 形成空洞
				    float circleSize = 0.05*(1.0+0.3*sin(_Time.y*_Size));//让大小变化点
				    float val = smoothstep(circleSize, -0, module);//反转 形成点
                    color += fixed4(val,val,val,val) * rgrid.x;
                 }
                
                return color * saturate(_Time.y);//增加渐入
            }
            ENDCG
        }
    }
}
