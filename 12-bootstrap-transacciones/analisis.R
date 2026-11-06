# Proyecto 12 | Bootstrap de media y desviación estándar
# Montos de transacciones financieras (miles de pesos)
# Datos originales del examen final. R base, sin paquetes.

# 1. Ingreso los 20 montos de la práctica
montos <- c(12.4, 15.1, 14.3, 18.6, 13.7, 16.2, 21.5, 17.4, 19.8, 14.9,
            16.7, 22.1, 18.3, 15.8, 20.4, 13.2, 17.9, 24.6, 16.5, 19.1)

# 2. Primero calculo el promedio y la desviación estándar
cat("Media:", round(mean(montos), 3), "\n")
cat("Desviación estándar:", round(sd(montos), 3), "\n")

# 3. Intervalo clásico del 95 % para la media
ic_clasico <- t.test(montos, conf.level = 0.95)$conf.int
cat("\nIntervalo clásico para la media:\n")
print(round(ic_clasico, 4))

# 4. Bootstrap: 5,000 remuestras con reemplazo
# Fijo la semilla para poder repetir la simulación.
# sample.kind = "Rejection" corresponde al ejercicio original (R >= 3.6).
RNGkind(kind = "Mersenne-Twister", normal.kind = "Inversion",
        sample.kind = "Rejection")
set.seed(20261011)
B <- 5000

remuestras <- replicate(B, sample(montos, size = length(montos), replace = TRUE))

# 5. Uso las MISMAS remuestras para los dos intervalos
medias_boot <- colMeans(remuestras)
desviaciones_boot <- apply(remuestras, 2, sd)

ic_media_boot <- quantile(medias_boot, probs = c(0.025, 0.975))
ic_sd_boot <- quantile(desviaciones_boot, probs = c(0.025, 0.975))

cat("\nIntervalo Bootstrap para la media:\n")
print(round(ic_media_boot, 4))
cat("\nIntervalo Bootstrap para la desviación estándar:\n")
print(round(ic_sd_boot, 4))

# 6. Gráficos de las distribuciones Bootstrap
if (!dir.exists("figuras")) dir.create("figuras")
png("figuras/bootstrap-media.png", width = 1000, height = 650, res = 140)
hist(medias_boot, breaks = 30, col = "#B9E0DA", border = "white",
     main = "Bootstrap: medias de las remuestras",
     xlab = "Media (miles de pesos)")
abline(v = ic_media_boot, col = "#D09244", lwd = 2, lty = 2)
dev.off()

png("figuras/bootstrap-desviacion.png", width = 1000, height = 650, res = 140)
hist(desviaciones_boot, breaks = 30, col = "#B9E0DA", border = "white",
     main = "Bootstrap: desviación estándar",
     xlab = "Desviación estándar (miles de pesos)")
abline(v = ic_sd_boot, col = "#D09244", lwd = 2, lty = 2)
dev.off()

# Bootstrap no corrige una mala muestra ni reemplaza datos faltantes.
