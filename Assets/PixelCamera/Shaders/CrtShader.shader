// Ported from MattiasCRT https://www.shadertoy.com/view/Ms23DR
// Loosely based on postprocessing shader by inigo quilez, License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

Shader "PixelCamera/CrtShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
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

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;

			float2 curve(float2 uv)
			{
				uv = (uv - 0.5) * 2.0;
				uv = mul(uv, 1.1);
				uv.x = mul(uv.x, 1.0 + pow((abs(uv.y) / 16.0), 2.0));
				uv.y = mul(uv.y, 1.0 + pow((abs(uv.x) / 9.0), 2.0));
				uv = (uv / 2.0) + 0.5;
				uv = uv * 0.92 + 0.04;
				return uv;
			}

			float4 scanlines(float2 fragCoord)
			{
				float2 q = fragCoord.xy / _ScreenParams.xy;
				float2 uv = q;
				uv = curve(uv);
				float3 oricol = tex2D(_MainTex, float2(q.x, q.y)).xyz;
				float3 col;
				float x = sin(0.3 * _Time.y + uv.y * 21.0) * sin(0.7 * _Time.y + uv.y * 29.0) * sin(0.3 + 0.33 * _Time.y + uv.y * 31.0) * 0.0017;

				col.r = tex2D(_MainTex, float2(x + uv.x + 0.001, uv.y + 0.001)).x + 0.05;
				col.g = tex2D(_MainTex, float2(x + uv.x + 0.000, uv.y - 0.002)).y + 0.05;
				col.b = tex2D(_MainTex, float2(x + uv.x - 0.002, uv.y + 0.000)).z + 0.05;
				col.r += 0.08 * tex2D(_MainTex, 0.75 * float2(x + 0.025, -0.027) + float2(uv.x + 0.001, uv.y + 0.001)).x;
				col.g += 0.05 * tex2D(_MainTex, 0.75 * float2(x + -0.022, -0.02) + float2(uv.x + 0.000, uv.y - 0.002)).y;
				col.b += 0.08 * tex2D(_MainTex, 0.75 * float2(x + -0.02, -0.018) + float2(uv.x - 0.002, uv.y + 0.000)).z;

				col = clamp(col * 0.6 + 0.4 * col * col * 1.0, 0.0, 1.0);

				float vig = (0.0 + 1.0 * 16.0 * uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y));
				float powvig = pow(vig, 0.3);
				col *= float3(powvig, powvig, powvig);

				col *= float3(0.95, 1.05, 0.95);
				col *= 2.8;

				float scans = clamp(0.35 + 0.35 * sin(3.5 * _Time.y + uv.y * _ScreenParams.y * 1.5), 0.0, 1.0);

				float s = pow(scans, 1.7);
				float sec = 0.4 + 0.7 * s;
				col = col * float3(sec, sec, sec);

				col *= 1.0 + 0.01 * sin(110.0 * _Time.y);
				if (uv.x < 0.0 || uv.x > 1.0)
					col *= 0.0;
				if (uv.y < 0.0 || uv.y > 1.0)
					col *= 0.0;

				float loo = clamp((fmod(fragCoord.x, 2.0) - 1.0)*2.0, 0.0, 1.0);
				col *= 1.0 - 0.65 * float3(loo, loo, loo);

				return float4(col, 1.0);
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return scanlines(i.uv * _ScreenParams.xy);
			}
			ENDCG
		}
	}
}