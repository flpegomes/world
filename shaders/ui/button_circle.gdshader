shader_type canvas_item;

uniform vec4 stone_dark : source_color = vec4(0.25, 0.25, 0.28, 1.0);
uniform vec4 stone_mid : source_color = vec4(0.4, 0.4, 0.42, 1.0);
uniform vec4 stone_light : source_color = vec4(0.55, 0.55, 0.58, 1.0);
uniform vec4 metal_color : source_color = vec4(0.35, 0.32, 0.28, 1.0);

uniform int pixel_size : hint_range(1, 16) = 4;
uniform bool pressed = false;
uniform float border_pixels : hint_range(1.0, 8.0) = 2.0;

// Pixelizar UV
vec2 pixelate(vec2 uv, float pixels) {
    return floor(uv * pixels) / pixels;
}

// Hash para ruído de pixel art
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void fragment() {
    // Calcular tamanho em pixels
    vec2 resolution = 1.0 / TEXTURE_PIXEL_SIZE;
    float pixels = min(resolution.x, resolution.y) / float(pixel_size);
    
    // Pixelizar coordenadas
    vec2 pixel_uv = pixelate(UV, pixels);
    vec2 uv = UV - 0.5;
    vec2 pixel_pos = floor((UV - 0.5) * pixels);
    
    // Tamanho do botão em pixels
    vec2 button_size = vec2(pixels * 0.45);
    vec2 abs_pos = abs(pixel_pos);
    
    // Borda em pixels
    float border = border_pixels;
    
    // Determinar região
    bool is_inside = abs_pos.x < button_size.x && abs_pos.y < button_size.y;
    bool is_border = abs_pos.x >= button_size.x - border || abs_pos.y >= button_size.y - border;
    bool is_outer_border = abs_pos.x >= button_size.x - 1.0 || abs_pos.y >= button_size.y - 1.0;
    
    // Calcular cantos arredondados (pixel art style)
    vec2 corner_dist = abs_pos - (button_size - vec2(2.0));
    bool is_corner = corner_dist.x > 0.0 && corner_dist.y > 0.0;
    float corner_radius = length(corner_dist);
    bool cut_corner = is_corner && corner_radius > 1.5;
    
    // Alpha
    float alpha = is_inside && !cut_corner ? 1.0 : 0.0;
    
    // Ruído para textura de pedra
    float noise_val = hash(pixel_pos);
    
    // Cor base
    vec3 final_color = stone_mid.rgb;
    
    if (!pressed) {
        // Estado normal - iluminado em cima
        if (is_outer_border) {
            // Borda externa escura
            final_color = stone_dark.rgb * 0.7;
        } else if (is_border) {
            // Borda metálica
            final_color = metal_color.rgb;
            if (pixel_pos.y < -button_size.y + border + 1.0) {
                final_color = stone_light.rgb; // Borda superior clara
            }
        } else {
            // Centro com gradiente
            float gradient = (pixel_pos.y / button_size.y) * 0.3;
            final_color = mix(stone_light.rgb, stone_mid.rgb, 0.5 + gradient);
            
            // Adicionar textura de pedra
            if (noise_val > 0.7) {
                final_color = mix(final_color, stone_dark.rgb, 0.3);
            } else if (noise_val > 0.9) {
                final_color = mix(final_color, stone_light.rgb, 0.2);
            }
        }
        
        // Highlight no topo (pixel art bevel)
        if (pixel_pos.y <= -button_size.y + border + 2.0 && !is_border) {
            final_color = stone_light.rgb;
        }
        
        // Sombra embaixo
        if (pixel_pos.y >= button_size.y - border - 2.0 && !is_border) {
            final_color = stone_dark.rgb;
        }
        
    } else {
        // Estado pressionado - invertido
        if (is_outer_border) {
            final_color = stone_light.rgb * 0.9;
        } else if (is_border) {
            final_color = metal_color.rgb * 0.8;
            if (pixel_pos.y > button_size.y - border - 1.0) {
                final_color = stone_dark.rgb;
            }
        } else {
            float gradient = (pixel_pos.y / button_size.y) * 0.3;
            final_color = mix(stone_dark.rgb, stone_mid.rgb, 0.3 - gradient);
            
            if (noise_val > 0.7) {
                final_color = mix(final_color, stone_dark.rgb * 0.8, 0.3);
            }
        }
        
        // Sombra no topo quando pressionado
        if (pixel_pos.y <= -button_size.y + border + 2.0 && !is_border) {
            final_color = stone_dark.rgb * 0.7;
        }
    }
    
    // Adicionar rivet/parafusos nos cantos (detalhe medieval)
    vec2 rivet_pos = abs_pos - (button_size - vec2(border + 1.0));
    if (length(rivet_pos) < 0.8 && !is_outer_border) {
        final_color = metal_color.rgb * 1.2;
    }
    
    COLOR = vec4(final_color, alpha);
}