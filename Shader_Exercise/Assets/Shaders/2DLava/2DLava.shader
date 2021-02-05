Shader "Shader_Exercise/2DLava"
{
    Properties
    {
        _NoiseTex ("_NoiseTex", 2D) = "white" {}
	    _GridSize ("SparkGridSize", float) = 30
    	_RotSpeed ("Rot Speed", float) = 1
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
			float _RotSpeed;
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

            float _Noise( in float2 x ){ return VNoise(x*0.75);}

			float2 Gradn(float2 p)
			{
				float ep = .09;
				float gradx = _Noise(float2(p.x+ep,p.y))-_Noise(float2(p.x-ep,p.y));
				float grady = _Noise(float2(p.x,p.y+ep))-_Noise(float2(p.x,p.y-ep));
				return float2(gradx,grady);
			}

			float FlowFBM(in float2 p)
			{
				float z=2.;
				float rz = 0.;
				float2 bp = p;
				for (float i= 1.;i < 9.;i++ )
				{
					//让不同的层都添加不同的运动速度 形成一种明显的 层次感
					p += _Time.y*_RotSpeed*.0006;
					bp += _Time.y*_RotSpeed*0.00006;
					//获取梯度
					float2 gr = Gradn(i*p*1.54+_Time.y*_RotSpeed*.14)*4.;
					//添加旋转 让不同的图层拥有不同的旋转速度，形成整体有扭曲的感觉
					float2x2 rot = Rot2DRad(_Time.y*_RotSpeed*0.6-(0.05*p.x+0.07*p.y)*30.);
					gr = mul(rot,gr);
					p += gr*.5;
					//FBM实现
					rz+= (sin(_Noise(p)*7.)*0.5+0.5)/z;
					//插值调整每层之间效果
					p = lerp(bp,p,.77);
					//FBM 常规操作
					z *= 1.4;
					p *= 2.;
					bp *= 1.9;
				}
				return rz;	
			}

            fixed4 frag (v2f i) : SV_Target
            {
            	fixed2 uv = i.uv;
				uv*= _GridSize;
				float val = FlowFBM(uv);
				val = Remap(0.,1.,0.6,1.,val);//重映射
				fixed4 col = fixed4(Blackbody(val),1);
				return col;
            }
            ENDCG
        }
    }
}
