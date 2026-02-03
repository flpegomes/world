shader_type canvas_item;

uniform vec4 cor_spray : source_color = vec4(0.29, 0.55, 0.42, 1.0);
uniform float irregularidade : hint_range(0.2, 0.6) = 0.5;
uniform float suavidade : hint_range(0.0, 0.1) = 0.08;
uniform float escala_ruido : hint_range(10.0, 100.0) = 80.0;
uniform float seed : hint_range(0.0, 100.0) = 100.0;

/* --- NOVO: controle de fill --- */
uniform float fill_amount : hint_range(0.0, 1.0) = 0.0;   // 0 = vazio, 1 = cheio
uniform float fill_suave : hint_range(0.0, 0.1) = 0.02;    // suavidade da borda do fill
uniform float fill_irregular : hint_range(0.0, 0.2) = 0.06; // quanto o fill "morde" com ruído

// Ruído multi-octave para bordas mais orgânicas
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;

    for(int i = 0; i < 4; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void fragment() {
    vec2 uv = UV;

    /* --- Seu alpha de spray (igual ao original) --- */
    vec2 centro = abs(uv - 0.5) * 2.0;
    float dist = max(centro.x, centro.y);

    float ruido = fbm((uv + seed) * escala_ruido);

    dist += ruido * irregularidade - irregularidade * 0.5;

    float alpha = 1.0 - smoothstep(1.0 - suavidade, 1.0, dist);

    float textura_interna = fbm(uv * escala_ruido * 0.5) * 0.1;
    alpha *= (1.0 - textura_interna);

    /* --- NOVO: máscara de fill esquerda->direita --- */
    // ruído extra só pra “quebrar” a linha do fill, opcional
    float ruido_fill = fbm((uv + seed * 0.17) * (escala_ruido * 0.35));
    float limite = fill_amount + (ruido_fill - 0.5) * fill_irregular;

    // 1.0 à esquerda do limite, 0.0 à direita, com borda suave
    float mask_fill = 1.0 - smoothstep(limite - fill_suave, limite, uv.x);

    alpha *= mask_fill;

    COLOR = vec4(cor_spray.rgb, cor_spray.a * alpha);
}
