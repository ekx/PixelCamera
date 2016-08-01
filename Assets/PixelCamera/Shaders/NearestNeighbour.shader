// Ported from AntiAliased Nearest Neighbor http://board.byuu.org/phpbb3/viewtopic.php?f=8&t=523#p11297
// by jimbo1qaz
// Licensed MIT

Shader "PixelCamera/NearestNeighbour"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SourceTex ("Source Texture", 2D) = "white" {}
		_SourceParams ("Source Params", Vector) = (0, 0, 0, 0)
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			#define NOT(fl) (1-fl)
			#define YES(fl) fl

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
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _SourceTex;
			float4 _SourceParams;

			float3 percent(float ssize, float tsize, float coord)
			{
				float minfull = (coord * tsize - 0.5) / tsize * ssize;
				float maxfull = (coord * tsize + 0.5) / tsize * ssize;

				float realfull = floor(maxfull);

				if (minfull > realfull)
				{
					return float3(1, (realfull + 0.5) / ssize, (realfull + 0.5) / ssize);
				}

				return float3(
					(maxfull - realfull) / (maxfull - minfull),
					(realfull - 0.5) / ssize,
					(realfull + 0.5) / ssize
				);
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float3 xstuff = percent(_SourceParams.x, _ScreenParams.x, i.uv.x);
				float3 ystuff = percent(_SourceParams.y, _ScreenParams.y, i.uv.y);

				float xkeep = xstuff[0];
				float ykeep = ystuff[0];

				fixed4 result =
					NOT(xkeep) * NOT(ykeep) * tex2D(_SourceTex, float2(xstuff[1], ystuff[1])) +
					YES(xkeep) * NOT(ykeep) * tex2D(_SourceTex, float2(xstuff[2], ystuff[1])) +
					NOT(xkeep) * YES(ykeep) * tex2D(_SourceTex, float2(xstuff[1], ystuff[2])) +
					YES(xkeep) * YES(ykeep) * tex2D(_SourceTex, float2(xstuff[2], ystuff[2]));

				return fixed4(result.rgb, 1);
			}
			ENDCG
		}
	}
}
