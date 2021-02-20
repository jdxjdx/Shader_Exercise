
#include "Lighting.cginc"
#include "UnityCG.cginc"

sampler2D _MainTex;
float4 _MainTex_ST;
sampler2D _Noise;
float4 _Noise_ST;

fixed4 _Color;
fixed4 _Specular;
fixed _Shininess;

fixed _FurLength;
fixed _FurRadius;
fixed _FurThinness;
fixed _Timing;

fixed _OcclusionPower;
fixed4 _OcclusionColor;

fixed4 _ForceGlobal;
fixed4 _ForceLocal;

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : NORMAL;
    float2 noise : TEXCOORD1;

};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 vertex : SV_POSITION;
    float2 noise : TEXCOORD1;
    float4 lightMul : TEXCOORD2; //用来储存与albedo相乘的颜色，例如漫反射，光照遮蔽
    float4 lightAdd : TEXCOORD3; //用来储存与albedo相加的颜色，例如轮廓光，高光
    float3 worldNormal: TEXCOORD4;
    float3 worldPos: TEXCOORD5;
};

v2f vert_base(appdata_base v)
{
    v2f o;
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
    o.worldNormal = UnityObjectToWorldNormal(v.normal);
    o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

    return o;
}

fixed4 frag_base(v2f i): SV_Target
{
    
    fixed3 worldNormal = normalize(i.worldNormal);
    fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
    fixed3 worldView = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
    fixed3 worldHalf = normalize(worldView + worldLight);
    
    fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color;
    fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
    fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(worldNormal, worldLight));
    fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal, worldHalf)), _Shininess);

    fixed3 color = ambient + diffuse + specular;
    
    return fixed4(color, 1.0);
}

v2f vert (appdata v)
{
    v2f o;
    float3 p = v.vertex + v.normal * _FurLength * FURSTEP;
    p += clamp(mul(unity_WorldToObject, _ForceGlobal).xyz + _ForceLocal.xyz, -1, 1) * pow(FURSTEP, 3) * _FurLength;
    o.vertex = UnityObjectToClipPos(float4(p,1.0));
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.noise = TRANSFORM_TEX(v.noise, _Noise);

    fixed Occlusion = saturate(pow(FURSTEP,_OcclusionPower) * 2.5);//FURSTEP不大于1
    fixed3 occlusionColor = lerp(_OcclusionColor,1,Occlusion);
    o.lightMul.rgb = occlusionColor;
    
    return o;
}

float4 frag(v2f i) : SV_Target{
    fixed3 albedo = tex2D(_MainTex,i.uv).rgb;
    fixed3 noise = tex2D(_Noise, i.noise * _FurThinness).rgb;
    //fixed alpha = saturate(noise - FURSTEP * _FurRadius);//==线性变化模拟不够真实 参考https://zhuanlan.zhihu.com/p/122405983
    //fixed alpha = saturate(noise - FURSTEP * FURSTEP * _FurRadius);
    fixed alpha = saturate(noise.r*2 - (FURSTEP * FURSTEP + (FURSTEP * _FurRadius)) * _Timing);
    fixed3 finalColor = albedo * i.lightMul.rgb;
    return fixed4(finalColor,alpha);
}