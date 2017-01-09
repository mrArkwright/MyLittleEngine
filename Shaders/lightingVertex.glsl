//
//  lightingVertex.glsl
//  My Little Engine
//
//  Created by Jannik Theiß on 26.12.2016.
//
//

#version 150

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

in vec3 position;
in vec3 normal;

out vec3 Normal;
out vec3 FragmentPosition;

void main(void) {
	gl_Position = projection * view * model * vec4(position, 1.0);
	FragmentPosition = vec3(model * vec4(position, 1.0));
	Normal = mat3(transpose(inverse(model))) * normal;
}
