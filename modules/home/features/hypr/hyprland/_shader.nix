''
  #version 300 es
  precision mediump float;

  in vec2 v_texcoord;
  uniform sampler2D tex;
  uniform float time;
  out vec4 fragColor;

  void main() {
      vec2 tc = vec2(v_texcoord.x, v_texcoord.y);

      float dx = abs(0.5 - tc.x);
      float dy = abs(0.5 - tc.y);
      dx *= dx;
      dy *= dy;

      tc.x -= 0.5;
      tc.x *= 1.0 + (dy * 0.2);
      tc.x += 0.5;

      tc.y -= 0.5;
      tc.y *= 1.0 + (dx * 0.2);
      tc.y += 0.5;

      vec4 color;
      color.r = texture(tex, tc).r;
      color.g = texture(tex, tc).g;
      color.b = texture(tex, tc).b;
      color.a = 1.0;

      if (mod(gl_FragCoord.y, 2.0) < 1.0) color.rgb *= 0.88;

      float noise = (fract(sin(dot(tc.xy, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 0.02;
      color.rgb += noise;

      float vignette = smoothstep(0.8, 0.2, dx + dy);
      color.rgb *= vignette;

      float lines = sin(tc.y * 40.0) * 0.02;
      color.rgb *= 1.0 - lines;

      color.rgb = vec3(color.r * 1.2, color.g * 1.0, color.b * 0.8);

      if (tc.y > 1.0 || tc.x < 0.0 || tc.x > 1.0 || tc.y < 0.0)
          color = vec4(0.0);

      fragColor = color;
  }
''
