# Proyecto 04 | Comparación de dos medias
# ¿La nueva tecnología agrícola mejora el rendimiento del cultivo?
# Datos originales del laboratorio de Análisis Estadístico y Simulación.
# Todo se hace en R base, sin instalar paquetes.

# 1. Rendimientos en quintales por tarea (20 productores por grupo)
tradicional <- c(4.8, 5.1, 4.6, 5.0, 4.7, 5.2, 4.9, 5.3, 4.5, 5.0,
                 4.8, 5.1, 4.7, 5.2, 4.9, 5.0, 4.6, 5.3, 4.8, 5.1)

nueva_tecnologia <- c(5.5, 5.8, 5.2, 6.0, 5.6, 5.9, 5.4, 6.1, 5.3, 5.7,
                      5.8, 5.5, 5.9, 6.2, 5.4, 5.7, 5.6, 6.0, 5.3, 5.8)

# 2. Primero reviso los promedios y qué tanto varían los rendimientos
resumen <- data.frame(
  Grupo = c("Tradicional", "Nueva tecnología"),
  Productores = c(length(tradicional), length(nueva_tecnologia)),
  Promedio = round(c(mean(tradicional), mean(nueva_tecnologia)), 3),
  Desviacion = round(c(sd(tradicional), sd(nueva_tecnologia)), 3)
)
print(resumen)

diferencia <- mean(nueva_tecnologia) - mean(tradicional)
cat("\nDiferencia de promedios:", round(diferencia, 3), "quintales por tarea\n")

# 3. Intervalo de confianza del 95 % para la diferencia de medias
# Uso Welch porque no necesito asumir que los dos grupos tienen igual varianza.
intervalo <- t.test(nueva_tecnologia, tradicional, conf.level = 0.95)
cat("\nIntervalo de confianza del 95 % para la diferencia:\n")
print(round(intervalo$conf.int[1:2], 4))

# 4. Prueba de hipótesis: ¿la nueva tecnología tiene un promedio mayor?
# H0: el promedio de la nueva tecnología no es mayor.
# H1: el promedio de la nueva tecnología sí es mayor.
prueba <- t.test(nueva_tecnologia, tradicional, alternative = "greater")
cat("\nValor p de la prueba unilateral:", signif(prueba$p.value, 4), "\n")

if (prueba$p.value < 0.05) {
  cat("Conclusión: hay evidencia de un rendimiento promedio mayor con la nueva tecnología.\n")
} else {
  cat("Conclusión: no hay evidencia suficiente de un rendimiento promedio mayor.\n")
}

# 5. Bootstrap: repito el muestreo 1,000 veces en cada grupo
# Así veo cómo puede cambiar la diferencia de promedios entre muestras.
set.seed(123)
B <- 1000

diferencias_boot <- replicate(B, {
  muestra_nueva <- sample(nueva_tecnologia, replace = TRUE)
  muestra_tradicional <- sample(tradicional, replace = TRUE)
  mean(muestra_nueva) - mean(muestra_tradicional)
})

ic_boot <- quantile(diferencias_boot, c(0.025, 0.975))
cat("\nIntervalo Bootstrap del 95 % (1,000 remuestras):\n")
print(round(ic_boot, 4))

# 6. Dos gráficos sencillos para acompañar el análisis
if (!dir.exists("figuras")) dir.create("figuras")

png("figuras/comparacion-rendimientos.png", width = 1050, height = 680, res = 140)
boxplot(tradicional, nueva_tecnologia,
        names = c("Tradicional", "Nueva tecnología"),
        col = c("#DCE7EF", "#B7DCD5"),
        ylab = "Quintales por tarea",
        main = "Rendimiento por tecnología")
points(1:2, c(mean(tradicional), mean(nueva_tecnologia)), pch = 19, col = "#0B6975")
dev.off()

png("figuras/bootstrap-diferencias.png", width = 1050, height = 680, res = 140)
hist(diferencias_boot, breaks = 25,
     col = "#B7DCD5", border = "white",
     main = "Bootstrap: diferencia de promedios",
     xlab = "Nueva tecnología - Tradicional (quintales por tarea)")
abline(v = diferencia, col = "#14394D", lwd = 3)
abline(v = ic_boot, col = "#C17D3B", lwd = 2, lty = 2)
dev.off()

# Importante: la diferencia observada no demuestra causalidad por sí sola.
# Haría falta conocer cómo fueron asignados los productores a cada grupo.
