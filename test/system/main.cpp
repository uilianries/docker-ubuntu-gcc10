#include <cstdio>
#include <cstdlib>
#include <iostream>
#include "GL/freeglut.h"


void error_handler(const char *fmt, va_list ap) {
    std::cerr << "glut error: ";
    vfprintf(stderr, fmt, ap);
    std::cerr << std::endl;
}

void warning_handler(const char *fmt, va_list ap) {
    std::cout << "glut warning: ";
    vfprintf(stdout, fmt, ap);
    std::cout << std::endl;
}

void renderScene(void) {

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glBegin(GL_TRIANGLES);
        glVertex3f(-0.5,-0.5,0.0);
        glVertex3f(0.5,0.0,0.0);
        glVertex3f(0.0,0.5,0.0);
    glEnd();

        glutSwapBuffers();
}

int main(int argc, char **argv) {
    glutInit(&argc, argv);
    glutInitErrorFunc(error_handler);
    glutInitWarningFunc(warning_handler);
    std::cout << "FreeGLUT version: " << glutGet(GLUT_VERSION) << std::endl;
    return EXIT_SUCCESS;
}