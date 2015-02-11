
// Source code for GLSL Perlin noise courtesy of:
// https://github.com/ashima/webgl-noise/wiki

uniform sampler2D tex0; // image texture
uniform float radius;   // (0.0 ... 0.5)
uniform float time;     // timing for animation
uniform float waviness; // strength of the waves (0.0 ... 1.0)

// uniform sampler2D tex1;
// uniform sampler2D tex2;
// uniform int mixType;

varying vec4 vertTexCoord;

// this function calculates the angle of the 2D vector from origin to end
float calcAngle(vec2 origin, vec2 end){
    float angle = atan(end.x-origin.x, origin.y-end.y);
    return angle;
}

void main(void) {
	vec2 p = vertTexCoord.xy; // put texture coordinates in vec2 p for convenience
  vec2 center = vec2(0.5, 0.5); // center of (distorted) circle
  vec2 offset = p - center; // vector between current p and center of circles
  float dist = sqrt(dot(offset,offset)); // length of offset (distance)
  float p_sin = sin(calcAngle(center, p)*10.0); // strength of wave-distortion for current p
  float wave_sin = sin(time*3.0); // strength of wave-distortion for current time (frame)

  float waved_radius = radius + wave_sin * p_sin * waviness * 0.1;

  vec4 colorFinal;

  if(dist > waved_radius)
    colorFinal = texture2D(tex0, p); // simply take color from texture
  else
    colorFinal = vec4(1.0);

	// set the fragment color to the final calculated color
	gl_FragColor = colorFinal;
}
