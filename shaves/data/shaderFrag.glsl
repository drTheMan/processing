
// Source code for GLSL Perlin noise courtesy of:
// https://github.com/ashima/webgl-noise/wiki

uniform sampler2D tex0;
uniform float radius;
uniform float time;

// uniform sampler2D tex1;
// uniform sampler2D tex2;
// uniform int mixType;

varying vec4 vertTexCoord;

void main(void) {
	vec2 p = vertTexCoord.xy; // put texture coordinates in vec2 p for convenience

  vec2 center = vec2(0.5, 0.5); // center

  vec2 offset = p - center;
  float dist = sqrt(dot(offset,offset));

  vec4 colorFinal;

  if(dist > radius)
    colorFinal = texture2D(tex0, p); // simply take color from texture
  else
    colorFinal = vec4(1.0);

	// set the fragment color to the final calculated color
	gl_FragColor = colorFinal;
}
