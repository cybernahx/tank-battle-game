import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class ExplosionEffect extends ParticleSystemComponent {
  ExplosionEffect({required Vector2 position})
      : super(
          position: position,
          particle: _createExplosionParticle(),
        );

  static Particle _createExplosionParticle() {
    final random = Random();
    return Particle.generate(
      count: 15,
      lifespan: 0.5,
      generator: (i) {
        final angle = random.nextDouble() * 2 * pi;
        final speed = 50 + random.nextDouble() * 100;
        final velocity = Vector2(cos(angle) * speed, sin(angle) * speed);
        
        return AcceleratedParticle(
          acceleration: Vector2(0, 100), // Gravity
          speed: velocity,
          child: ComputedParticle(
            renderer: (canvas, particle) {
              final opacity = 1.0 - particle.progress;
              final size = 4.0 * (1.0 - particle.progress * 0.5);
              
              final paint = Paint()
                ..color = Color.lerp(
                  Colors.orange,
                  Colors.red,
                  particle.progress,
                )!.withAlpha((opacity * 255).toInt());
              
              canvas.drawCircle(Offset.zero, size, paint);
            },
          ),
        );
      },
    );
  }
}

class MuzzleFlash extends CircleComponent {
  MuzzleFlash({required Vector2 position})
      : super(
          position: position,
          radius: 8,
          paint: Paint()..color = Colors.yellow,
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    radius -= dt * 30;
    if (radius <= 0) {
      removeFromParent();
    }
  }
}
