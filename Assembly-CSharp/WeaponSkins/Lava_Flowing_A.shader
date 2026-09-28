Shader "CMune/Lava/Opaque_Flowing" {
Properties {
 _MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
 _BumpMap ("Normalmap", 2D) = "bump" {}
 _Caustics ("_Caustics", 2D) = "black" {}
 _Cube ("Reflection Cubemap", CUBE) = "black" {}
 _Color ("Main Color", Color) = (0,0.313726,0.65098,1)
 _WaterColor_Dark ("Dark Water Color", Color) = (1,1,1,1)
 _ReflectColor ("Reflection Color", Color) = (0.72549,0.992157,1,0.501961)
 _Specular ("_Specular", Float) = 2
 _Gloss ("_Gloss", Float) = 1
 _Tiling ("_Tiling", Float) = 1.5
}
SubShader { 
 Tags { "QUEUE"="Geometry" "IGNOREPROJECTOR"="False" "RenderType"="Opaque" }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardBase" "SHADOWSUPPORT"="true" "QUEUE"="Geometry" "IGNOREPROJECTOR"="False" "RenderType"="Opaque" }
Program "vp" {
// Platform d3d11 had shader errors
//   Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
//   Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
//   Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
//   Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Vector 15 [unity_Scale]
"3.0-!!ARBvp1.0
PARAM c[16] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R3.xyz, R0, vertex.attrib[14].w;
MOV R0, c[14];
MOV R1.xyz, c[13];
MOV R1.w, c[0].x;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[15].w, -vertex.position;
DP4 R1.z, R0, c[11];
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
DP3 R0.y, R3, c[5];
DP3 R0.w, -R2, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[2], R0, c[15].w;
DP3 R0.y, R3, c[6];
DP3 R0.w, -R2, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[3], R0, c[15].w;
DP3 R0.y, R3, c[7];
DP3 R0.w, -R2, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
DP3 result.texcoord[0].y, R2, R3;
DP3 result.texcoord[5].y, R3, R1;
MUL result.texcoord[4], R0, c[15].w;
DP3 result.texcoord[0].z, vertex.normal, R2;
DP3 result.texcoord[0].x, R2, vertex.attrib[14];
DP3 result.texcoord[5].z, vertex.normal, R1;
DP3 result.texcoord[5].x, vertex.attrib[14], R1;
MOV result.texcoord[6].xyz, c[0].y;
MOV result.texcoord[1].zw, vertex.texcoord[1].xyxy;
MOV result.texcoord[1].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 42 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_Scale]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c15, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c13, r0
mov r0, c9
dp4 r4.y, c13, r0
mov r1.w, c15.x
mov r1.xyz, c12
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c14.w, -v0
mov r1, c8
dp4 r4.x, c13, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c14.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c14.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o1.y, r2, r3
dp3 o6.y, r3, r4
mul o5, r0, c14.w
dp3 o1.z, v2, r2
dp3 o1.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mov o7.xyz, c15.y
mov o2.zw, v4.xyxy
mov o2.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_ProjectionParams]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_Scale]
"3.0-!!ARBvp1.0
PARAM c[17] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R3.xyz, R0, vertex.attrib[14].w;
MOV R0, c[15];
MOV R1.xyz, c[13];
MOV R1.w, c[0].x;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[16].w, -vertex.position;
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
DP4 R1.z, R0, c[11];
DP3 R0.w, -R2, c[5];
DP3 result.texcoord[5].y, R3, R1;
DP3 R0.y, R3, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[2], R0, c[16].w;
DP3 R0.w, -R2, c[6];
DP3 R0.y, R3, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[3], R0, c[16].w;
DP3 R0.w, -R2, c[7];
DP3 R0.y, R3, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
MUL result.texcoord[4], R0, c[16].w;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP3 result.texcoord[5].z, vertex.normal, R1;
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
DP3 result.texcoord[5].x, vertex.attrib[14], R1;
DP3 result.texcoord[0].y, R2, R3;
DP3 result.texcoord[0].z, vertex.normal, R2;
DP3 result.texcoord[0].x, R2, vertex.attrib[14];
MUL R2.xyz, R0.xyww, c[0].z;
MOV R1.x, R2;
MUL R1.y, R2, c[14].x;
ADD result.texcoord[7].xy, R1, R2.z;
MOV result.position, R0;
MOV result.texcoord[7].zw, R0;
MOV result.texcoord[6].xyz, c[0].y;
MOV result.texcoord[1].zw, vertex.texcoord[1].xyxy;
MOV result.texcoord[1].xy, vertex.texcoord[0];
END
# 48 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_Scale]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c17, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c15, r0
mov r0, c9
dp4 r4.y, c15, r0
mov r1.w, c17.x
mov r1.xyz, c12
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c16.w, -v0
mov r1, c8
dp4 r4.x, c15, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c16.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c16.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c16.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c17.z
mul r1.y, r1, c13.x
dp3 o1.y, r2, r3
dp3 o6.y, r3, r4
dp3 o1.z, v2, r2
dp3 o1.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o8.xy, r1.z, c14.zwzw, r1
mov o0, r0
mov o8.zw, r0
mov o7.xyz, c17.y
mov o2.zw, v4.xyxy
mov o2.xy, v3
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Vector 15 [unity_4LightPosX0]
Vector 16 [unity_4LightPosY0]
Vector 17 [unity_4LightPosZ0]
Vector 18 [unity_4LightAtten0]
Vector 19 [unity_LightColor0]
Vector 20 [unity_LightColor1]
Vector 21 [unity_LightColor2]
Vector 22 [unity_LightColor3]
Vector 23 [unity_Scale]
"3.0-!!ARBvp1.0
PARAM c[24] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..23] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R3.xyz, vertex.normal, c[23].w;
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[16];
DP3 R0.y, R3, c[6];
DP3 R3.w, R3, c[5];
MUL R2, R1, R0.y;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[15];
MAD R2, R0, R3.w, R2;
MUL R1, R1, R1;
MAD R1, R0, R0, R1;
DP4 R3.w, vertex.position, c[7];
ADD R0, -R3.w, c[17];
MAD R1, R0, R0, R1;
DP3 R3.x, R3, c[7];
MAD R0, R0, R3.x, R2;
MUL R2, R1, c[18];
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[20];
MAD R2.xyz, R0.x, c[19], R1;
MAD R2.xyz, R0.z, c[21], R2;
MOV R1.xyz, vertex.attrib[14];
MUL R0.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R1.zxyw, -R0;
MOV R1.xyz, c[13];
MUL R3.xyz, R0, vertex.attrib[14].w;
MAD result.texcoord[6].xyz, R0.w, c[22], R2;
MOV R1.w, c[0].x;
MOV R0, c[14];
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[23].w, -vertex.position;
DP4 R1.z, R0, c[11];
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
DP3 R0.y, R3, c[5];
DP3 R0.w, -R2, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[2], R0, c[23].w;
DP3 R0.y, R3, c[6];
DP3 R0.w, -R2, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[3], R0, c[23].w;
DP3 R0.y, R3, c[7];
DP3 R0.w, -R2, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
DP3 result.texcoord[0].y, R2, R3;
DP3 result.texcoord[5].y, R3, R1;
MUL result.texcoord[4], R0, c[23].w;
DP3 result.texcoord[0].z, vertex.normal, R2;
DP3 result.texcoord[0].x, R2, vertex.attrib[14];
DP3 result.texcoord[5].z, vertex.normal, R1;
DP3 result.texcoord[5].x, vertex.attrib[14], R1;
MOV result.texcoord[1].zw, vertex.texcoord[1].xyxy;
MOV result.texcoord[1].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 74 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_4LightPosX0]
Vector 15 [unity_4LightPosY0]
Vector 16 [unity_4LightPosZ0]
Vector 17 [unity_4LightAtten0]
Vector 18 [unity_LightColor0]
Vector 19 [unity_LightColor1]
Vector 20 [unity_LightColor2]
Vector 21 [unity_LightColor3]
Vector 22 [unity_Scale]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c23, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mul r3.xyz, v2, c22.w
dp4 r0.x, v0, c5
add r1, -r0.x, c15
dp3 r0.y, r3, c5
dp3 r3.w, r3, c4
mul r2, r1, r0.y
dp4 r0.x, v0, c4
add r0, -r0.x, c14
mad r2, r0, r3.w, r2
mul r1, r1, r1
mad r1, r0, r0, r1
dp4 r3.w, v0, c6
add r0, -r3.w, c16
mad r1, r0, r0, r1
dp3 r3.x, r3, c6
mad r0, r0, r3.x, r2
mul r2, r1, c17
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c23.x
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c23.y
mul r0, r0, r1
mul r1.xyz, r0.y, c19
mad r1.xyz, r0.x, c18, r1
mad r1.xyz, r0.z, c20, r1
mov r1.w, c23.x
mov r0.xyz, v1
mad o7.xyz, r0.w, c21, r1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mov r1.xyz, c12
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c13, r0
mov r0, c9
dp4 r4.y, c13, r0
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c22.w, -v0
mov r1, c8
dp4 r4.x, c13, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c22.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c22.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
dp3 o1.y, r2, r3
dp3 o6.y, r3, r4
mul o5, r0, c22.w
dp3 o1.z, v2, r2
dp3 o1.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mov o2.zw, v4.xyxy
mov o2.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_ProjectionParams]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 19 [unity_4LightAtten0]
Vector 20 [unity_LightColor0]
Vector 21 [unity_LightColor1]
Vector 22 [unity_LightColor2]
Vector 23 [unity_LightColor3]
Vector 24 [unity_Scale]
"3.0-!!ARBvp1.0
PARAM c[25] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..24] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R3.xyz, vertex.normal, c[24].w;
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[17];
DP3 R0.y, R3, c[6];
DP3 R3.w, R3, c[5];
MUL R2, R1, R0.y;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[16];
MAD R2, R0, R3.w, R2;
MUL R1, R1, R1;
MAD R1, R0, R0, R1;
DP4 R3.w, vertex.position, c[7];
ADD R0, -R3.w, c[18];
MAD R1, R0, R0, R1;
DP3 R3.x, R3, c[7];
MAD R0, R0, R3.x, R2;
MUL R2, R1, c[19];
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[21];
MAD R2.xyz, R0.x, c[20], R1;
MAD R2.xyz, R0.z, c[22], R2;
MOV R1.xyz, vertex.attrib[14];
MUL R0.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R1.zxyw, -R0;
MOV R1.xyz, c[13];
MUL R3.xyz, R0, vertex.attrib[14].w;
MAD result.texcoord[6].xyz, R0.w, c[23], R2;
MOV R1.w, c[0].x;
MOV R0, c[15];
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[24].w, -vertex.position;
DP4 R1.x, R0, c[9];
DP4 R1.y, R0, c[10];
DP4 R1.z, R0, c[11];
DP3 R0.w, -R2, c[5];
DP3 result.texcoord[5].y, R3, R1;
DP3 R0.y, R3, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[2], R0, c[24].w;
DP3 R0.w, -R2, c[6];
DP3 R0.y, R3, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[3], R0, c[24].w;
DP3 R0.w, -R2, c[7];
DP3 R0.y, R3, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
MUL result.texcoord[4], R0, c[24].w;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP3 result.texcoord[5].z, vertex.normal, R1;
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
DP3 result.texcoord[5].x, vertex.attrib[14], R1;
DP3 result.texcoord[0].y, R2, R3;
DP3 result.texcoord[0].z, vertex.normal, R2;
DP3 result.texcoord[0].x, R2, vertex.attrib[14];
MUL R2.xyz, R0.xyww, c[0].z;
MOV R1.x, R2;
MUL R1.y, R2, c[14].x;
ADD result.texcoord[7].xy, R1, R2.z;
MOV result.position, R0;
MOV result.texcoord[7].zw, R0;
MOV result.texcoord[1].zw, vertex.texcoord[1].xyxy;
MOV result.texcoord[1].xy, vertex.texcoord[0];
END
# 80 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 19 [unity_4LightAtten0]
Vector 20 [unity_LightColor0]
Vector 21 [unity_LightColor1]
Vector 22 [unity_LightColor2]
Vector 23 [unity_LightColor3]
Vector 24 [unity_Scale]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c25, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mul r3.xyz, v2, c24.w
dp4 r0.x, v0, c5
add r1, -r0.x, c17
dp3 r0.y, r3, c5
dp3 r3.w, r3, c4
mul r2, r1, r0.y
dp4 r0.x, v0, c4
add r0, -r0.x, c16
mad r2, r0, r3.w, r2
mul r1, r1, r1
mad r1, r0, r0, r1
dp4 r3.w, v0, c6
add r0, -r3.w, c18
mad r1, r0, r0, r1
dp3 r3.x, r3, c6
mad r0, r0, r3.x, r2
mul r2, r1, c19
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c25.x
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c25.y
mul r0, r0, r1
mul r1.xyz, r0.y, c21
mad r1.xyz, r0.x, c20, r1
mad r1.xyz, r0.z, c22, r1
mov r1.w, c25.x
mov r0.xyz, v1
mad o7.xyz, r0.w, c23, r1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mov r1.xyz, c12
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c15, r0
mov r0, c9
dp4 r4.y, c15, r0
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c24.w, -v0
mov r1, c8
dp4 r4.x, c15, r1
dp3 r0.y, r3, c4
dp3 r0.w, -r2, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o3, r0, c24.w
dp3 r0.y, r3, c5
dp3 r0.w, -r2, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o4, r0, c24.w
dp3 r0.y, r3, c6
dp3 r0.w, -r2, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o5, r0, c24.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c25.z
mul r1.y, r1, c13.x
dp3 o1.y, r2, r3
dp3 o6.y, r3, r4
dp3 o1.z, v2, r2
dp3 o1.x, r2, v1
dp3 o6.z, v2, r4
dp3 o6.x, v1, r4
mad o8.xy, r1.z, c14.zwzw, r1
mov o0, r0
mov o8.zw, r0
mov o2.zw, v4.xyxy
mov o2.xy, v3
"
}
}
Program "fp" {
// Platform d3d11 skipped due to earlier errors
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_WaterColor_Dark]
Vector 4 [_ReflectColor]
Float 5 [_Specular]
Float 6 [_Gloss]
Float 7 [_Tiling]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_Cube] CUBE 2
SetTexture 3 [_Caustics] 2D 3
"3.0-!!ARBfp1.0
PARAM c[11] = { program.local[0..7],
		{ 0.025, 2, 1, 0.035 },
		{ 0, 128, 0.1, 3.375 },
		{ 0.2199707, 0.70703125, 0.070983887, 1.5 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.zw, fragment.texcoord[1].xyxy, c[7].x;
MOV R0.xy, c[8].xwzw;
MAD R1.xy, R0.x, c[0], R0.zwzw;
MAD R1.zw, R0.y, c[0].xyxy, R0;
TEX R0.yw, R1, texture[0], 2D;
TEX R1.yw, R1.zwzw, texture[1], 2D;
MAD R5.xy, R1.wyzw, c[8].y, -c[8].z;
MAD R0.xy, R0.wyzw, c[8].y, -c[8].z;
MUL R0.zw, R0.xyxy, R0.xyxy;
ADD_SAT R0.z, R0, R0.w;
MUL R1.xy, R5, R5;
ADD_SAT R0.w, R1.x, R1.y;
ADD R0.z, -R0, c[8];
ADD R0.w, -R0, c[8].z;
RSQ R0.w, R0.w;
RCP R5.z, R0.w;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R1.x, fragment.texcoord[0], fragment.texcoord[0];
ADD R0.xyz, R0, R5;
MOV R0.w, c[9].x;
DP4 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R0;
DP3 R3.x, R2, fragment.texcoord[2];
DP3 R3.y, R2, fragment.texcoord[3];
DP3 R3.z, R2, fragment.texcoord[4];
DP3 R0.w, R2, R2;
MOV R0.xyz, fragment.texcoord[5];
RSQ R1.x, R1.x;
MAD R1.xyz, R1.x, fragment.texcoord[0], R0;
RSQ R0.x, R0.w;
MUL R0.xyz, R0.x, R2;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R1;
DP3 R0.w, R0, R1;
DP3 R1.w, R0, fragment.texcoord[5];
MAX R1.w, R1, c[9].x;
MUL R0.xyz, R1.w, c[1];
MAX R1.w, R0, c[9].x;
MOV R1.xyz, c[10];
MOV R0.w, c[9].y;
MUL R0.w, R0, c[6].x;
DP3 R1.x, R1, c[1];
POW R0.w, R1.w, R0.w;
MUL R0.w, R0, R1.x;
MUL R1, R0, c[8].y;
MOV R0.x, fragment.texcoord[2].w;
MOV R0.z, fragment.texcoord[4].w;
MOV R0.y, fragment.texcoord[3].w;
DP3 R2.w, R3, R0;
MUL R4.xyz, R3, R2.w;
MUL R0.w, R1, c[5].x;
MUL R3.xyz, R1, R0.w;
MAD R0.xyz, -R4, c[8].y, R0;
MAD R1.xyz, R1, c[3], R3;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R2;
MOV R3.xyz, c[2];
DP3 R0.w, fragment.texcoord[0], fragment.texcoord[0];
ADD R3.xyz, -R3, c[3];
TEX R0.xyz, R0, texture[2], CUBE;
MAD R0.xyz, R0, R3, c[2];
MUL R3.xy, fragment.texcoord[1], c[9].w;
RSQ R0.w, R0.w;
MAD R4.xy, R5, c[9].z, R3;
MUL R3.xyz, R0.w, fragment.texcoord[0];
DP3 R0.w, R3, R2;
TEX R2.xyz, R4, texture[3], 2D;
MAD R2.xyz, R2, c[10].w, -R0.w;
ADD R3.xyz, -R0, c[4];
ADD R2.xyz, R2, c[8].z;
MAD R2.xyz, R2, R3, R0;
MAD R0.xyz, fragment.texcoord[6], c[3], R1;
ADD result.color.xyz, R0, R2;
MOV result.color.w, c[8].z;
END
# 78 instructions, 6 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_WaterColor_Dark]
Vector 4 [_ReflectColor]
Float 5 [_Specular]
Float 6 [_Gloss]
Float 7 [_Tiling]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_Cube] CUBE 2
SetTexture 3 [_Caustics] 2D 3
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
def c8, 0.02500000, 2.00000000, -1.00000000, 1.00000000
def c9, 0.03500000, 0.00000000, 128.00000000, 3.37500000
def c10, 0.21997070, 0.70703125, 0.07098389, 0.10000000
def c11, 1.50000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xy
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
mov r0.zw, c0.xyxy
mul r1.xy, v1, c7.x
mov r0.xy, c0
mad r0.xy, c8.x, r0, r1
mad r1.xy, c9.x, r0.zwzw, r1
texld r1.yw, r1, s1
mad_pp r5.xy, r1.wyzw, c8.y, c8.z
texld r0.yw, r0, s0
mad_pp r0.xy, r0.wyzw, c8.y, c8.z
mul_pp r0.zw, r0.xyxy, r0.xyxy
add_pp_sat r0.z, r0, r0.w
mul_pp r1.xy, r5, r5
add_pp_sat r0.w, r1.x, r1.y
add_pp r0.z, -r0, c8.w
add_pp r0.w, -r0, c8
rsq_pp r0.w, r0.w
rcp_pp r5.z, r0.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
add r0.xyz, r0, r5
mov r0.w, c9.y
dp4 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3_pp r0.x, r2, r2
rsq_pp r0.x, r0.x
dp3_pp r0.w, v0, v0
mul_pp r0.xyz, r0.x, r2
mov_pp r1.xyz, v5
rsq_pp r0.w, r0.w
mad_pp r3.xyz, r0.w, v0, r1
dp3_pp r1.x, r0, v5
dp3_pp r0.w, r3, r3
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r3
dp3_pp r0.x, r0, r3
mov_pp r0.w, c6.x
max_pp r1.x, r1, c9.y
mov_pp r3.xyz, c1
mul_pp r2.w, c9.z, r0
max_pp r1.w, r0.x, c9.y
pow r0, r1.w, r2.w
dp3_pp r0.y, c10, r3
mul r1.w, r0.x, r0.y
mul_pp r1.xyz, r1.x, c1
mul_pp r1, r1, c8.y
dp3_pp r3.x, r2, v2
dp3_pp r3.y, r2, v3
dp3_pp r3.z, r2, v4
mov r0.x, v2.w
mov r0.z, v4.w
mov r0.y, v3.w
dp3 r2.w, r3, r0
mul r4.xyz, r3, r2.w
mul_pp r0.w, r1, c5.x
mul_pp r3.xyz, r1, r0.w
mad r0.xyz, -r4, c8.y, r0
mad_pp r1.xyz, r1, c3, r3
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul r2.xyz, r0.w, r2
mov r3.xyz, c3
dp3 r0.w, v0, v0
add r3.xyz, -c2, r3
texld r0.xyz, r0, s2
mad r0.xyz, r0, r3, c2
mul r3.xy, v1, c9.w
rsq r0.w, r0.w
mad r4.xy, r5, c10.w, r3
mul r3.xyz, r0.w, v0
dp3 r0.w, r3, r2
texld r2.xyz, r4, s3
mad r2.xyz, r2, c11.x, -r0.w
add r3.xyz, -r0, c4
add r2.xyz, r2, c8.w
mad r2.xyz, r2, r3, r0
mad_pp r0.xyz, v6, c3, r1
add_pp oC0.xyz, r0, r2
mov_pp oC0.w, c8
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_WaterColor_Dark]
Vector 4 [_ReflectColor]
Float 5 [_Specular]
Float 6 [_Gloss]
Float 7 [_Tiling]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_Cube] CUBE 2
SetTexture 3 [_Caustics] 2D 3
SetTexture 4 [_ShadowMapTexture] 2D 4
"3.0-!!ARBfp1.0
PARAM c[11] = { program.local[0..7],
		{ 0.025, 2, 1, 0.035 },
		{ 0, 128, 0.1, 3.375 },
		{ 0.2199707, 0.70703125, 0.070983887, 1.5 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.zw, fragment.texcoord[1].xyxy, c[7].x;
MOV R0.xy, c[8].xwzw;
MAD R1.xy, R0.x, c[0], R0.zwzw;
MAD R1.zw, R0.y, c[0].xyxy, R0;
TEX R0.yw, R1, texture[0], 2D;
TEX R1.yw, R1.zwzw, texture[1], 2D;
MAD R5.xy, R1.wyzw, c[8].y, -c[8].z;
MAD R0.xy, R0.wyzw, c[8].y, -c[8].z;
MUL R0.zw, R0.xyxy, R0.xyxy;
ADD_SAT R0.z, R0, R0.w;
MUL R1.xy, R5, R5;
ADD_SAT R0.w, R1.x, R1.y;
ADD R0.z, -R0, c[8];
ADD R0.w, -R0, c[8].z;
RSQ R0.w, R0.w;
RCP R5.z, R0.w;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
ADD R0.xyz, R0, R5;
MOV R0.w, c[9].x;
DP4 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R0;
DP3 R0.w, fragment.texcoord[0], fragment.texcoord[0];
MOV R0.xyz, fragment.texcoord[5];
RSQ R0.w, R0.w;
MAD R1.xyz, R0.w, fragment.texcoord[0], R0;
DP3 R0.y, R1, R1;
RSQ R0.w, R0.y;
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL R1.xyz, R0.w, R1;
MUL R0.xyz, R0.x, R2;
DP3 R0.w, R0, fragment.texcoord[5];
DP3 R0.x, R0, R1;
MAX R1.y, R0.w, c[9].x;
MAX R1.x, R0, c[9];
MOV R0.xyz, c[10];
MOV R0.w, c[9].y;
DP3 R3.x, R2, fragment.texcoord[2];
DP3 R3.y, R2, fragment.texcoord[3];
DP3 R3.z, R2, fragment.texcoord[4];
DP3 R0.y, R0, c[1];
MUL R0.w, R0, c[6].x;
POW R0.x, R1.x, R0.w;
MUL R0.w, R0.x, R0.y;
MUL R0.xyz, R1.y, c[1];
TXP R1.x, fragment.texcoord[7], texture[4], 2D;
MUL R0, R1.x, R0;
MUL R1, R0, c[8].y;
MOV R0.x, fragment.texcoord[2].w;
MOV R0.z, fragment.texcoord[4].w;
MOV R0.y, fragment.texcoord[3].w;
DP3 R2.w, R3, R0;
MUL R4.xyz, R3, R2.w;
MUL R0.w, R1, c[5].x;
MUL R3.xyz, R1, R0.w;
MAD R0.xyz, -R4, c[8].y, R0;
MAD R1.xyz, R1, c[3], R3;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R2;
MOV R3.xyz, c[2];
DP3 R0.w, fragment.texcoord[0], fragment.texcoord[0];
ADD R3.xyz, -R3, c[3];
TEX R0.xyz, R0, texture[2], CUBE;
MAD R0.xyz, R0, R3, c[2];
MUL R3.xy, fragment.texcoord[1], c[9].w;
RSQ R0.w, R0.w;
MAD R4.xy, R5, c[9].z, R3;
MUL R3.xyz, R0.w, fragment.texcoord[0];
DP3 R0.w, R3, R2;
TEX R2.xyz, R4, texture[3], 2D;
MAD R2.xyz, R2, c[10].w, -R0.w;
ADD R3.xyz, -R0, c[4];
ADD R2.xyz, R2, c[8].z;
MAD R2.xyz, R2, R3, R0;
MAD R0.xyz, fragment.texcoord[6], c[3], R1;
ADD result.color.xyz, R0, R2;
MOV result.color.w, c[8].z;
END
# 80 instructions, 6 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_WaterColor_Dark]
Vector 4 [_ReflectColor]
Float 5 [_Specular]
Float 6 [_Gloss]
Float 7 [_Tiling]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_Cube] CUBE 2
SetTexture 3 [_Caustics] 2D 3
SetTexture 4 [_ShadowMapTexture] 2D 4
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_cube s2
dcl_2d s3
dcl_2d s4
def c8, 0.02500000, 2.00000000, -1.00000000, 1.00000000
def c9, 0.03500000, 0.00000000, 128.00000000, 3.37500000
def c10, 0.21997070, 0.70703125, 0.07098389, 0.10000000
def c11, 1.50000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xy
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
mov r0.zw, c0.xyxy
mul r1.xy, v1, c7.x
mov r0.xy, c0
mad r0.xy, c8.x, r0, r1
mad r1.xy, c9.x, r0.zwzw, r1
texld r1.yw, r1, s1
mad_pp r5.xy, r1.wyzw, c8.y, c8.z
texld r0.yw, r0, s0
mad_pp r0.xy, r0.wyzw, c8.y, c8.z
mul_pp r0.zw, r0.xyxy, r0.xyxy
add_pp_sat r0.z, r0, r0.w
mul_pp r1.xy, r5, r5
add_pp_sat r0.w, r1.x, r1.y
add_pp r0.z, -r0, c8.w
add_pp r0.w, -r0, c8
rsq_pp r0.w, r0.w
rcp_pp r5.z, r0.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3_pp r1.x, v0, v0
add r0.xyz, r0, r5
mov r0.w, c9.y
dp4 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3_pp r0.x, r2, r2
rsq_pp r0.w, r0.x
dp3_pp r3.x, r2, v2
dp3_pp r3.y, r2, v3
dp3_pp r3.z, r2, v4
mov_pp r0.xyz, v5
rsq_pp r1.x, r1.x
mad_pp r1.xyz, r1.x, v0, r0
mul_pp r0.xyz, r0.w, r2
dp3_pp r1.w, r0, v5
dp3_pp r0.w, r1, r1
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r1
dp3_pp r0.x, r0, r1
mov_pp r0.w, c6.x
mul_pp r1.y, c9.z, r0.w
max_pp r1.x, r0, c9.y
pow r0, r1.x, r1.y
mov_pp r1.xyz, c1
dp3_pp r0.y, c10, r1
max_pp r1.w, r1, c9.y
mul r0.w, r0.x, r0.y
mul_pp r0.xyz, r1.w, c1
texldp r1.x, v7, s4
mul_pp r0, r1.x, r0
mul_pp r1, r0, c8.y
mov r0.x, v2.w
mov r0.z, v4.w
mov r0.y, v3.w
dp3 r2.w, r3, r0
mul r4.xyz, r3, r2.w
mul_pp r0.w, r1, c5.x
mul_pp r3.xyz, r1, r0.w
mad r0.xyz, -r4, c8.y, r0
mad_pp r1.xyz, r1, c3, r3
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul r2.xyz, r0.w, r2
mov r3.xyz, c3
dp3 r0.w, v0, v0
add r3.xyz, -c2, r3
texld r0.xyz, r0, s2
mad r0.xyz, r0, r3, c2
mul r3.xy, v1, c9.w
rsq r0.w, r0.w
mad r4.xy, r5, c10.w, r3
mul r3.xyz, r0.w, v0
dp3 r0.w, r3, r2
texld r2.xyz, r4, s3
mad r2.xyz, r2, c11.x, -r0.w
add r3.xyz, -r0, c4
add r2.xyz, r2, c8.w
mad r2.xyz, r2, r3, r0
mad_pp r0.xyz, v6, c3, r1
add_pp oC0.xyz, r0, r2
mov_pp oC0.w, c8
"
}
}
 }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardAdd" "QUEUE"="Geometry" "IGNOREPROJECTOR"="False" "RenderType"="Opaque" }
  ZWrite Off
  Fog {
   Color (0,0,0,0)
  }
  Blend One One
Program "vp" {
// Platform d3d11 had shader errors
//   Keywords { "POINT" }
//   Keywords { "DIRECTIONAL" }
//   Keywords { "SPOT" }
//   Keywords { "POINT_COOKIE" }
//   Keywords { "DIRECTIONAL_COOKIE" }
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_Scale]
"3.0-!!ARBvp1.0
PARAM c[20] = { { 1 },
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, c[17];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[19].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[18];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[11];
DP4 R3.x, R0, c[9];
DP4 R3.y, R0, c[10];
MAD R0.xyz, R3, c[19].w, -vertex.position;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MOV result.texcoord[0].zw, vertex.texcoord[1].xyxy;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 34 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_Scale]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c19, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.w, c19.x
mov r0.xyz, c16
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c18.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c17, r0
mov r0, c9
dp4 r4.y, c17, r0
mov r1, c8
dp4 r4.x, c17, r1
mad r0.xyz, r4, c18.w, -v0
dp3 o2.y, r0, r2
dp3 o2.z, v2, r0
dp3 o2.x, r0, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o3.y, r2, r3
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
dp4 o4.z, r0, c14
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mov o1.zw, v4.xyxy
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Matrix 5 [_World2Object]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Vector 11 [unity_Scale]
"3.0-!!ARBvp1.0
PARAM c[12] = { { 1 },
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, c[9];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[7];
DP4 R2.y, R1, c[6];
DP4 R2.x, R1, c[5];
MAD R2.xyz, R2, c[11].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[10];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[7];
DP4 R3.y, R0, c[6];
DP4 R3.x, R0, c[5];
DP3 result.texcoord[1].y, R3, R1;
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[1].z, vertex.normal, R3;
DP3 result.texcoord[1].x, R3, vertex.attrib[14];
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
MOV result.texcoord[0].zw, vertex.texcoord[1].xyxy;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 26 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_World2Object]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_WorldSpaceLightPos0]
Vector 10 [unity_Scale]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c11, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.w, c11.x
mov r0.xyz, c8
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
mad r3.xyz, r1, c10.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c6
dp4 r4.z, c9, r0
mov r0, c5
mov r1, c4
dp4 r4.y, c9, r0
dp4 r4.x, c9, r1
dp3 o2.y, r4, r2
dp3 o3.y, r2, r3
dp3 o2.z, v2, r4
dp3 o2.x, r4, v1
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
mov o1.zw, v4.xyxy
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_Scale]
"3.0-!!ARBvp1.0
PARAM c[20] = { { 1 },
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, c[17];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[19].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[18];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[11];
DP4 R3.x, R0, c[9];
DP4 R3.y, R0, c[10];
MAD R0.xyz, R3, c[19].w, -vertex.position;
DP4 R0.w, vertex.position, c[8];
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].w, R0, c[16];
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MOV result.texcoord[0].zw, vertex.texcoord[1].xyxy;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_Scale]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c19, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.w, c19.x
mov r0.xyz, c16
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c18.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c17, r0
mov r0, c9
dp4 r4.y, c17, r0
mov r1, c8
dp4 r4.x, c17, r1
mad r0.xyz, r4, c18.w, -v0
dp4 r0.w, v0, c7
dp3 o2.y, r0, r2
dp3 o2.z, v2, r0
dp3 o2.x, r0, v1
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o3.y, r2, r3
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
dp4 o4.w, r0, c15
dp4 o4.z, r0, c14
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mov o1.zw, v4.xyxy
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_Scale]
"3.0-!!ARBvp1.0
PARAM c[20] = { { 1 },
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, c[17];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[19].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[18];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[11];
DP4 R3.x, R0, c[9];
DP4 R3.y, R0, c[10];
MAD R0.xyz, R3, c[19].w, -vertex.position;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MOV result.texcoord[0].zw, vertex.texcoord[1].xyxy;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 34 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_Scale]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c19, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.w, c19.x
mov r0.xyz, c16
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c18.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c17, r0
mov r0, c9
dp4 r4.y, c17, r0
mov r1, c8
dp4 r4.x, c17, r1
mad r0.xyz, r4, c18.w, -v0
dp3 o2.y, r0, r2
dp3 o2.z, v2, r0
dp3 o2.x, r0, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o3.y, r2, r3
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
dp4 o4.z, r0, c14
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mov o1.zw, v4.xyxy
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Vector 19 [unity_Scale]
"3.0-!!ARBvp1.0
PARAM c[20] = { { 1 },
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, c[17];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[19].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[18];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[11];
DP4 R3.y, R0, c[10];
DP4 R3.x, R0, c[9];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[1].y, R3, R1;
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[1].z, vertex.normal, R3;
DP3 result.texcoord[1].x, R3, vertex.attrib[14];
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MOV result.texcoord[0].zw, vertex.texcoord[1].xyxy;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 32 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Vector 18 [unity_Scale]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c19, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.w, c19.x
mov r0.xyz, c16
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c18.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c17, r0
mov r0, c9
dp4 r4.y, c17, r0
mov r1, c8
dp4 r4.x, c17, r1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o2.y, r4, r2
dp3 o3.y, r2, r3
dp3 o2.z, v2, r4
dp3 o2.x, r4, v1
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mov o1.zw, v4.xyxy
mov o1.xy, v3
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}
}
Program "fp" {
// Platform d3d11 skipped due to earlier errors
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_WaterColor_Dark]
Float 3 [_Specular]
Float 4 [_Gloss]
Float 5 [_Tiling]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_LightTexture0] 2D 2
"3.0-!!ARBfp1.0
PARAM c[9] = { program.local[0..5],
		{ 0, 0.025, 2, 1 },
		{ 0.035, 128 },
		{ 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.zw, fragment.texcoord[0].xyxy, c[5].x;
MOV R0.y, c[6];
MAD R1.xy, R0.y, c[0], R0.zwzw;
TEX R1.yw, R1, texture[0], 2D;
MOV R0.x, c[7];
MAD R0.xy, R0.x, c[0], R0.zwzw;
TEX R0.yw, R0, texture[1], 2D;
MAD R0.xy, R0.wyzw, c[6].z, -c[6].w;
MAD R1.xy, R1.wyzw, c[6].z, -c[6].w;
MUL R0.zw, R1.xyxy, R1.xyxy;
ADD_SAT R0.z, R0, R0.w;
MUL R1.zw, R0.xyxy, R0.xyxy;
ADD_SAT R0.w, R1.z, R1;
ADD R0.z, -R0, c[6].w;
RSQ R0.z, R0.z;
ADD R0.w, -R0, c[6];
RSQ R0.w, R0.w;
RCP R1.z, R0.z;
RCP R0.z, R0.w;
ADD R1.xyz, R1, R0;
MOV R1.w, c[6].x;
DP4 R0.x, R1, R1;
RSQ R0.w, R0.x;
MUL R1.xyz, R0.w, R1;
DP3 R0.y, fragment.texcoord[1], fragment.texcoord[1];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
RSQ R0.x, R0.y;
DP3 R1.w, fragment.texcoord[2], fragment.texcoord[2];
MUL R1.xyz, R0.w, R1;
MUL R0.xyz, R0.x, fragment.texcoord[1];
RSQ R1.w, R1.w;
MAD R2.xyz, R1.w, fragment.texcoord[2], R0;
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
DP3 R0.w, R1, R2;
DP3 R1.y, R1, R0;
MAX R1.x, R0.w, c[6];
MOV R0.xyz, c[8];
MOV R0.w, c[7].y;
DP3 R0.y, R0, c[1];
MUL R0.w, R0, c[4].x;
POW R0.x, R1.x, R0.w;
MUL R1.w, R0.x, R0.y;
MAX R0.y, R1, c[6].x;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R1.xyz, R0.y, c[1];
TEX R0.w, R0.x, texture[2], 2D;
MUL R0, R0.w, R1;
MUL R0, R0, c[6].z;
MUL R0.w, R0, c[3].x;
MUL R1.xyz, R0, R0.w;
MAD result.color.xyz, R0, c[2], R1;
MOV result.color.w, c[6].x;
END
# 55 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_WaterColor_Dark]
Float 3 [_Specular]
Float 4 [_Gloss]
Float 5 [_Tiling]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_LightTexture0] 2D 2
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c6, 0.02500000, 2.00000000, -1.00000000, 1.00000000
def c7, 0.03500000, 0.00000000, 128.00000000, 0
def c8, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
mul r0.zw, v0.xyxy, c5.x
mov r0.xy, c0
mov r1.xy, c0
mad r1.xy, c6.x, r1, r0.zwzw
mad r0.xy, c7.x, r0, r0.zwzw
texld r1.yw, r1, s0
texld r0.yw, r0, s1
mad_pp r1.xy, r1.wyzw, c6.y, c6.z
mad_pp r0.xy, r0.wyzw, c6.y, c6.z
mul_pp r0.zw, r1.xyxy, r1.xyxy
add_pp_sat r0.z, r0, r0.w
mul_pp r1.zw, r0.xyxy, r0.xyxy
add_pp_sat r0.w, r1.z, r1
add_pp r0.z, -r0, c6.w
rsq_pp r0.z, r0.z
add_pp r0.w, -r0, c6
dp3_pp r1.w, v2, v2
rcp_pp r1.z, r0.z
rsq_pp r0.w, r0.w
rcp_pp r0.z, r0.w
add r0.xyz, r1, r0
mov r0.w, c7.y
dp4 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3_pp r1.x, v1, v1
rsq_pp r1.x, r1.x
dp3_pp r0.w, r0, r0
mul_pp r1.xyz, r1.x, v1
rsq_pp r1.w, r1.w
mad_pp r2.xyz, r1.w, v2, r1
rsq_pp r1.w, r0.w
mul_pp r0.xyz, r1.w, r0
dp3_pp r0.w, r2, r2
rsq_pp r1.w, r0.w
dp3_pp r0.w, r0, r1
mul_pp r1.xyz, r1.w, r2
dp3_pp r0.x, r0, r1
mov_pp r1.w, c4.x
mul_pp r0.y, c7.z, r1.w
max_pp r0.x, r0, c7.y
pow r1, r0.x, r0.y
mov_pp r0.xyz, c1
dp3_pp r0.x, c8, r0
mov r0.y, r1.x
mul r1.w, r0.y, r0.x
max_pp r0.y, r0.w, c7
dp3 r0.x, v3, v3
mul_pp r1.xyz, r0.y, c1
texld r0.x, r0.x, s2
mul_pp r0, r0.x, r1
mul_pp r0, r0, c6.y
mul_pp r0.w, r0, c3.x
mul_pp r1.xyz, r0, r0.w
mad_pp oC0.xyz, r0, c2, r1
mov_pp oC0.w, c7.y
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_WaterColor_Dark]
Float 3 [_Specular]
Float 4 [_Gloss]
Float 5 [_Tiling]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
"3.0-!!ARBfp1.0
PARAM c[9] = { program.local[0..5],
		{ 0, 0.025, 2, 1 },
		{ 0.035, 128 },
		{ 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
MUL R0.xy, fragment.texcoord[0], c[5].x;
MOV R0.z, c[6].y;
MAD R0.zw, R0.z, c[0].xyxy, R0.xyxy;
MOV R1.x, c[7];
MAD R0.xy, R1.x, c[0], R0;
TEX R1.yw, R0.zwzw, texture[0], 2D;
TEX R0.yw, R0, texture[1], 2D;
MAD R1.xy, R1.wyzw, c[6].z, -c[6].w;
MAD R0.xy, R0.wyzw, c[6].z, -c[6].w;
MUL R0.zw, R1.xyxy, R1.xyxy;
ADD_SAT R0.z, R0, R0.w;
MUL R1.zw, R0.xyxy, R0.xyxy;
ADD_SAT R0.w, R1.z, R1;
ADD R0.z, -R0, c[6].w;
RSQ R0.z, R0.z;
ADD R0.w, -R0, c[6];
DP3 R1.w, fragment.texcoord[2], fragment.texcoord[2];
RCP R1.z, R0.z;
RSQ R0.w, R0.w;
RCP R0.z, R0.w;
ADD R0.xyz, R1, R0;
MOV R0.w, c[6].x;
DP4 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.w, R0, R0;
RSQ R1.w, R1.w;
MOV R1.xyz, fragment.texcoord[1];
MAD R1.xyz, R1.w, fragment.texcoord[2], R1;
RSQ R1.w, R0.w;
MUL R0.xyz, R1.w, R0;
DP3 R0.w, R1, R1;
RSQ R1.w, R0.w;
DP3 R0.w, R0, fragment.texcoord[1];
MUL R1.xyz, R1.w, R1;
MAX R1.w, R0, c[6].x;
DP3 R0.w, R0, R1;
MUL R0.xyz, R1.w, c[1];
MOV R1.xyz, c[8];
MOV R1.w, c[7].y;
DP3 R1.x, R1, c[1];
MAX R0.w, R0, c[6].x;
MUL R1.w, R1, c[4].x;
POW R0.w, R0.w, R1.w;
MUL R0.w, R0, R1.x;
MUL R0, R0, c[6].z;
MUL R0.w, R0, c[3].x;
MUL R1.xyz, R0, R0.w;
MAD result.color.xyz, R0, c[2], R1;
MOV result.color.w, c[6].x;
END
# 50 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_WaterColor_Dark]
Float 3 [_Specular]
Float 4 [_Gloss]
Float 5 [_Tiling]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
"ps_3_0
dcl_2d s0
dcl_2d s1
def c6, 0.02500000, 2.00000000, -1.00000000, 1.00000000
def c7, 0.03500000, 0.00000000, 128.00000000, 0
def c8, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
mul r0.zw, v0.xyxy, c5.x
mov r0.xy, c0
mov r1.xy, c0
mad r1.xy, c6.x, r1, r0.zwzw
mad r0.xy, c7.x, r0, r0.zwzw
texld r1.yw, r1, s0
texld r0.yw, r0, s1
mad_pp r1.xy, r1.wyzw, c6.y, c6.z
mad_pp r0.xy, r0.wyzw, c6.y, c6.z
mul_pp r0.zw, r1.xyxy, r1.xyxy
add_pp_sat r0.z, r0, r0.w
mul_pp r1.zw, r0.xyxy, r0.xyxy
add_pp_sat r0.w, r1.z, r1
add_pp r0.z, -r0, c6.w
rsq_pp r0.z, r0.z
add_pp r0.w, -r0, c6
rcp_pp r1.z, r0.z
rsq_pp r0.w, r0.w
rcp_pp r0.z, r0.w
add r0.xyz, r1, r0
mov r0.w, c7.y
dp4 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
dp3_pp r0.w, v2, v2
mov_pp r0.xyz, v1
rsq_pp r0.w, r0.w
mad_pp r2.xyz, r0.w, v2, r0
dp3_pp r0.x, r2, r2
rsq_pp r0.w, r0.x
mul_pp r2.xyz, r0.w, r2
dp3_pp r0.w, r1, r2
dp3_pp r0.y, r1, v1
mov_pp r1.w, c4.x
max_pp r0.y, r0, c7
mul_pp r2.x, c7.z, r1.w
max_pp r0.w, r0, c7.y
pow r1, r0.w, r2.x
mov_pp r2.xyz, c1
dp3_pp r0.w, c8, r2
mul r0.w, r1.x, r0
mul_pp r0.xyz, r0.y, c1
mul_pp r0, r0, c6.y
mul_pp r0.w, r0, c3.x
mul_pp r1.xyz, r0, r0.w
mad_pp oC0.xyz, r0, c2, r1
mov_pp oC0.w, c7.y
"
}
SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_WaterColor_Dark]
Float 3 [_Specular]
Float 4 [_Gloss]
Float 5 [_Tiling]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_LightTexture0] 2D 2
SetTexture 3 [_LightTextureB0] 2D 3
"3.0-!!ARBfp1.0
PARAM c[9] = { program.local[0..5],
		{ 0, 0.5, 0.025, 2 },
		{ 1, 0.035, 128 },
		{ 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.xy, fragment.texcoord[0], c[5].x;
MOV R0.z, c[7].y;
MAD R1.xy, R0.z, c[0], R0;
MOV R0.z, c[6];
MAD R0.xy, R0.z, c[0], R0;
MOV R0.zw, c[7].xyxz;
TEX R2.yw, R0, texture[0], 2D;
TEX R1.yw, R1, texture[1], 2D;
MAD R0.xy, R2.wyzw, c[6].w, -R0.z;
MAD R1.xy, R1.wyzw, c[6].w, -R0.z;
MUL R1.zw, R0.xyxy, R0.xyxy;
ADD_SAT R0.z, R1, R1.w;
MUL R2.xy, R1, R1;
ADD_SAT R1.z, R2.x, R2.y;
ADD R0.z, -R0, c[7].x;
ADD R1.z, -R1, c[7].x;
RSQ R0.z, R0.z;
RSQ R1.z, R1.z;
DP3 R2.x, fragment.texcoord[2], fragment.texcoord[2];
RCP R0.z, R0.z;
RCP R1.z, R1.z;
ADD R1.xyz, R0, R1;
MOV R1.w, c[6].x;
DP4 R0.x, R1, R1;
RSQ R1.w, R0.x;
MUL R1.xyz, R1.w, R1;
DP3 R0.y, fragment.texcoord[1], fragment.texcoord[1];
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
RSQ R0.x, R0.y;
MUL R1.xyz, R1.w, R1;
MUL R0.xyz, R0.x, fragment.texcoord[1];
RSQ R2.x, R2.x;
MAD R2.xyz, R2.x, fragment.texcoord[2], R0;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
DP3 R1.w, R1, R2;
DP3 R1.y, R1, R0;
MOV R0.xyz, c[8];
DP3 R0.y, R0, c[1];
MAX R1.x, R1.w, c[6];
MUL R0.w, R0, c[4].x;
POW R0.x, R1.x, R0.w;
MUL R2.w, R0.x, R0.y;
MAX R0.y, R1, c[6].x;
DP3 R0.z, fragment.texcoord[3], fragment.texcoord[3];
MUL R2.xyz, R0.y, c[1];
RCP R0.x, fragment.texcoord[3].w;
MAD R0.xy, fragment.texcoord[3], R0.x, c[6].y;
TEX R0.w, R0, texture[2], 2D;
SLT R0.x, c[6], fragment.texcoord[3].z;
MUL R0.x, R0, R0.w;
TEX R1.w, R0.z, texture[3], 2D;
MUL R0.x, R0, R1.w;
MUL R0, R0.x, R2;
MUL R0, R0, c[6].w;
MUL R0.w, R0, c[3].x;
MUL R1.xyz, R0, R0.w;
MAD result.color.xyz, R0, c[2], R1;
MOV result.color.w, c[6].x;
END
# 61 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_WaterColor_Dark]
Float 3 [_Specular]
Float 4 [_Gloss]
Float 5 [_Tiling]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_LightTexture0] 2D 2
SetTexture 3 [_LightTextureB0] 2D 3
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c6, 0.00000000, 1.00000000, 0.50000000, 0.02500000
def c7, 2.00000000, -1.00000000, 0.03500000, 128.00000000
def c8, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
mul r0.zw, v0.xyxy, c5.x
mov r0.xy, c0
mov r1.xy, c0
mad r1.xy, c6.w, r1, r0.zwzw
mad r0.xy, c7.z, r0, r0.zwzw
texld r1.yw, r1, s0
texld r0.yw, r0, s1
mad_pp r1.xy, r1.wyzw, c7.x, c7.y
mad_pp r0.xy, r0.wyzw, c7.x, c7.y
mul_pp r0.zw, r1.xyxy, r1.xyxy
add_pp_sat r0.z, r0, r0.w
mul_pp r1.zw, r0.xyxy, r0.xyxy
add_pp_sat r0.w, r1.z, r1
add_pp r0.z, -r0, c6.y
rsq_pp r0.z, r0.z
add_pp r0.w, -r0, c6.y
dp3_pp r1.w, v2, v2
rcp_pp r1.z, r0.z
rsq_pp r0.w, r0.w
rcp_pp r0.z, r0.w
add r0.xyz, r1, r0
mov r0.w, c6.x
dp4 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3_pp r1.x, v1, v1
rsq_pp r1.x, r1.x
dp3_pp r0.w, r0, r0
mul_pp r1.xyz, r1.x, v1
rsq_pp r1.w, r1.w
mad_pp r2.xyz, r1.w, v2, r1
rsq_pp r1.w, r0.w
mul_pp r0.xyz, r1.w, r0
dp3_pp r0.w, r2, r2
rsq_pp r1.w, r0.w
dp3_pp r0.w, r0, r1
mul_pp r1.xyz, r1.w, r2
dp3_pp r0.x, r0, r1
mov_pp r1.w, c4.x
mul_pp r0.y, c7.w, r1.w
max_pp r0.x, r0, c6
pow r1, r0.x, r0.y
mov_pp r0.xyz, c1
dp3_pp r0.x, c8, r0
mov r0.y, r1.x
mul r1.w, r0.y, r0.x
max_pp r0.y, r0.w, c6.x
mul_pp r1.xyz, r0.y, c1
rcp r0.x, v3.w
mad r2.xy, v3, r0.x, c6.z
dp3 r0.x, v3, v3
texld r0.w, r2, s2
cmp r0.y, -v3.z, c6.x, c6
mul_pp r0.y, r0, r0.w
texld r0.x, r0.x, s3
mul_pp r0.x, r0.y, r0
mul_pp r0, r0.x, r1
mul_pp r0, r0, c7.x
mul_pp r0.w, r0, c3.x
mul_pp r1.xyz, r0, r0.w
mad_pp oC0.xyz, r0, c2, r1
mov_pp oC0.w, c6.x
"
}
SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_WaterColor_Dark]
Float 3 [_Specular]
Float 4 [_Gloss]
Float 5 [_Tiling]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_LightTexture0] CUBE 3
"3.0-!!ARBfp1.0
PARAM c[9] = { program.local[0..5],
		{ 0, 0.025, 2, 1 },
		{ 0.035, 128 },
		{ 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.zw, fragment.texcoord[0].xyxy, c[5].x;
MOV R0.y, c[6];
MAD R1.xy, R0.y, c[0], R0.zwzw;
TEX R1.yw, R1, texture[0], 2D;
MOV R0.x, c[7];
MAD R0.xy, R0.x, c[0], R0.zwzw;
TEX R0.yw, R0, texture[1], 2D;
MAD R1.xy, R1.wyzw, c[6].z, -c[6].w;
MAD R0.xy, R0.wyzw, c[6].z, -c[6].w;
MUL R0.zw, R1.xyxy, R1.xyxy;
ADD_SAT R0.z, R0, R0.w;
MUL R1.zw, R0.xyxy, R0.xyxy;
ADD_SAT R0.w, R1.z, R1;
ADD R0.z, -R0, c[6].w;
RSQ R0.z, R0.z;
ADD R0.w, -R0, c[6];
RCP R1.z, R0.z;
RSQ R0.w, R0.w;
RCP R0.z, R0.w;
ADD R0.xyz, R1, R0;
MOV R0.w, c[6].x;
DP4 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R1.w, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R1.w;
DP3 R0.w, fragment.texcoord[2], fragment.texcoord[2];
MUL R0.xyz, R0.x, fragment.texcoord[1];
RSQ R0.w, R0.w;
MAD R2.xyz, R0.w, fragment.texcoord[2], R0;
DP3 R0.w, R1, R1;
RSQ R1.w, R0.w;
MUL R1.xyz, R1.w, R1;
DP3 R2.w, R2, R2;
RSQ R0.w, R2.w;
MUL R2.xyz, R0.w, R2;
DP3 R0.y, R1, R0;
DP3 R0.x, R1, R2;
MAX R1.y, R0, c[6].x;
MAX R1.x, R0, c[6];
MOV R0.xyz, c[8];
MOV R0.w, c[7].y;
DP3 R0.y, R0, c[1];
MUL R0.w, R0, c[4].x;
POW R0.x, R1.x, R0.w;
MUL R2.w, R0.x, R0.y;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R2.xyz, R1.y, c[1];
TEX R0.w, fragment.texcoord[3], texture[3], CUBE;
TEX R1.w, R0.x, texture[2], 2D;
MUL R0.x, R1.w, R0.w;
MUL R0, R0.x, R2;
MUL R0, R0, c[6].z;
MUL R0.w, R0, c[3].x;
MUL R1.xyz, R0, R0.w;
MAD result.color.xyz, R0, c[2], R1;
MOV result.color.w, c[6].x;
END
# 57 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_WaterColor_Dark]
Float 3 [_Specular]
Float 4 [_Gloss]
Float 5 [_Tiling]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_LightTextureB0] 2D 2
SetTexture 3 [_LightTexture0] CUBE 3
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c6, 0.02500000, 2.00000000, -1.00000000, 1.00000000
def c7, 0.03500000, 0.00000000, 128.00000000, 0
def c8, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
mul r0.zw, v0.xyxy, c5.x
mov r0.xy, c0
mov r1.xy, c0
mad r1.xy, c6.x, r1, r0.zwzw
mad r0.xy, c7.x, r0, r0.zwzw
texld r1.yw, r1, s0
texld r0.yw, r0, s1
mad_pp r1.xy, r1.wyzw, c6.y, c6.z
mad_pp r0.xy, r0.wyzw, c6.y, c6.z
mul_pp r0.zw, r1.xyxy, r1.xyxy
add_pp_sat r0.z, r0, r0.w
mul_pp r1.zw, r0.xyxy, r0.xyxy
add_pp_sat r0.w, r1.z, r1
add_pp r0.z, -r0, c6.w
rsq_pp r0.z, r0.z
add_pp r0.w, -r0, c6
dp3_pp r1.w, v2, v2
rcp_pp r1.z, r0.z
rsq_pp r0.w, r0.w
rcp_pp r0.z, r0.w
add r0.xyz, r1, r0
mov r0.w, c7.y
dp4 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
dp3_pp r0.x, r1, r1
rsq_pp r0.w, r0.x
dp3_pp r0.y, v1, v1
rsq_pp r0.x, r0.y
mul_pp r0.xyz, r0.x, v1
rsq_pp r1.w, r1.w
mad_pp r2.xyz, r1.w, v2, r0
mul_pp r1.xyz, r0.w, r1
dp3_pp r0.y, r1, r0
dp3_pp r0.w, r2, r2
rsq_pp r0.x, r0.w
max_pp r0.w, r0.y, c7.y
mul_pp r0.xyz, r0.x, r2
dp3_pp r0.x, r1, r0
mov_pp r1.w, c4.x
mul_pp r0.y, c7.z, r1.w
max_pp r0.x, r0, c7.y
pow r1, r0.x, r0.y
mov_pp r0.xyz, c1
dp3_pp r0.x, c8, r0
mov r0.y, r1.x
mul r1.w, r0.y, r0.x
mul_pp r1.xyz, r0.w, c1
dp3 r0.x, v3, v3
texld r0.w, v3, s3
texld r0.x, r0.x, s2
mul r0.x, r0, r0.w
mul_pp r0, r0.x, r1
mul_pp r0, r0, c6.y
mul_pp r0.w, r0, c3.x
mul_pp r1.xyz, r0, r0.w
mad_pp oC0.xyz, r0, c2, r1
mov_pp oC0.w, c7.y
"
}
SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_WaterColor_Dark]
Float 3 [_Specular]
Float 4 [_Gloss]
Float 5 [_Tiling]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_LightTexture0] 2D 2
"3.0-!!ARBfp1.0
PARAM c[9] = { program.local[0..5],
		{ 0, 0.025, 2, 1 },
		{ 0.035, 128 },
		{ 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
MUL R0.xy, fragment.texcoord[0], c[5].x;
MOV R0.z, c[6].y;
MAD R0.zw, R0.z, c[0].xyxy, R0.xyxy;
MOV R1.x, c[7];
MAD R0.xy, R1.x, c[0], R0;
TEX R1.yw, R0.zwzw, texture[0], 2D;
TEX R0.yw, R0, texture[1], 2D;
MAD R1.xy, R1.wyzw, c[6].z, -c[6].w;
MAD R0.xy, R0.wyzw, c[6].z, -c[6].w;
MUL R0.zw, R1.xyxy, R1.xyxy;
ADD_SAT R0.z, R0, R0.w;
MUL R1.zw, R0.xyxy, R0.xyxy;
ADD_SAT R0.w, R1.z, R1;
ADD R0.z, -R0, c[6].w;
RSQ R0.z, R0.z;
ADD R0.w, -R0, c[6];
RCP R1.z, R0.z;
RSQ R0.w, R0.w;
RCP R0.z, R0.w;
ADD R0.xyz, R1, R0;
MOV R0.w, c[6].x;
DP4 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
DP3 R0.w, fragment.texcoord[2], fragment.texcoord[2];
MUL R0.xyz, R1.w, R0;
RSQ R0.w, R0.w;
MOV R1.xyz, fragment.texcoord[1];
MAD R1.xyz, R0.w, fragment.texcoord[2], R1;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R1;
DP3 R0.w, R0, fragment.texcoord[1];
DP3 R0.x, R0, R1;
MAX R1.y, R0.x, c[6].x;
MOV R0.xyz, c[8];
MOV R1.x, c[7].y;
DP3 R0.y, R0, c[1];
MUL R1.x, R1, c[4];
POW R0.x, R1.y, R1.x;
MAX R0.w, R0, c[6].x;
MUL R1.xyz, R0.w, c[1];
MUL R1.w, R0.x, R0.y;
TEX R0.w, fragment.texcoord[3], texture[2], 2D;
MUL R0, R0.w, R1;
MUL R0, R0, c[6].z;
MUL R0.w, R0, c[3].x;
MUL R1.xyz, R0, R0.w;
MAD result.color.xyz, R0, c[2], R1;
MOV result.color.w, c[6].x;
END
# 52 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_WaterColor_Dark]
Float 3 [_Specular]
Float 4 [_Gloss]
Float 5 [_Tiling]
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpMap] 2D 1
SetTexture 2 [_LightTexture0] 2D 2
"ps_3_0
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c6, 0.02500000, 2.00000000, -1.00000000, 1.00000000
def c7, 0.03500000, 0.00000000, 128.00000000, 0
def c8, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
mul r0.zw, v0.xyxy, c5.x
mov r0.xy, c0
mov r1.xy, c0
mad r1.xy, c6.x, r1, r0.zwzw
mad r0.xy, c7.x, r0, r0.zwzw
texld r1.yw, r1, s0
texld r0.yw, r0, s1
mad_pp r1.xy, r1.wyzw, c6.y, c6.z
mad_pp r0.xy, r0.wyzw, c6.y, c6.z
mul_pp r0.zw, r1.xyxy, r1.xyxy
add_pp_sat r0.z, r0, r0.w
mul_pp r1.zw, r0.xyxy, r0.xyxy
add_pp_sat r0.w, r1.z, r1
add_pp r0.z, -r0, c6.w
rsq_pp r0.z, r0.z
add_pp r0.w, -r0, c6
dp3_pp r1.w, v2, v2
rcp_pp r1.z, r0.z
rsq_pp r0.w, r0.w
rcp_pp r0.z, r0.w
add r0.xyz, r1, r0
mov r0.w, c7.y
dp4 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
dp3_pp r0.w, r0, v1
rsq_pp r1.w, r1.w
mov_pp r1.xyz, v1
mad_pp r1.xyz, r1.w, v2, r1
dp3_pp r1.w, r1, r1
rsq_pp r1.w, r1.w
mul_pp r1.xyz, r1.w, r1
dp3_pp r0.x, r0, r1
mov_pp r1.w, c4.x
mul_pp r0.y, c7.z, r1.w
max_pp r0.x, r0, c7.y
pow r1, r0.x, r0.y
mov_pp r0.xyz, c1
dp3_pp r0.x, c8, r0
mov r0.y, r1.x
max_pp r0.w, r0, c7.y
mul_pp r1.xyz, r0.w, c1
mul r1.w, r0.y, r0.x
texld r0.w, v3, s2
mul_pp r0, r0.w, r1
mul_pp r0, r0, c6.y
mul_pp r0.w, r0, c3.x
mul_pp r1.xyz, r0, r0.w
mad_pp oC0.xyz, r0, c2, r1
mov_pp oC0.w, c7.y
"
}
}
 }
}
Fallback "Diffuse"
}