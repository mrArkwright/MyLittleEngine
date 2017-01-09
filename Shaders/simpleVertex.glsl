//
//  simpleFragment.glsl
//  My Little Engine
//
//  Created by Jannik Theiß on 28.12.2016.
//
//

#version 150

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

in vec3 position;

void main(void) {
	gl_Position = projection * view * model * vec4(position, 1.0);
}
