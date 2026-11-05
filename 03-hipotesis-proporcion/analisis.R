# PROYECTO 03 | Prueba de hipótesis para una proporción
# Asignatura: Análisis Estadístico y Simulación
# Caso académico: morosidad en una cartera de préstamos personales
# Ejecutar desde la carpeta 03-hipotesis-proporcion/ (R base, sin paquetes).

# 1. Datos originales del ejercicio
n <- 400                 # clientes en la muestra
morosos <- 68            # clientes con morosidad
p_referencia <- 0.13     # referencia histórica (13 %)
alpha <- 0.05

stopifnot(n > 0, morosos >= 0, morosos <= n,
          p_referencia > 0, p_referencia < 1)

# 2. Estadística descriptiva
p_muestral <- morosos / n
no_morosos <- n - morosos
diferencia_pp <- (p_muestral - p_referencia) * 100

# 3. IC clásico del 95 % para una proporción (aproximación normal / Wald)
# Aquí utilizamos el error estándar estimado con la proporción muestral.
z_critico <- qnorm(1 - alpha / 2)
ee_estimado <- sqrt(p_muestral * (1 - p_muestral) / n)
ic_clasico <- p_muestral + c(-1, 1) * z_critico * ee_estimado

# 4. Prueba unilateral de hipótesis para una proporción
# H0: p <= 0.13 (calculamos el estadístico bajo p = 0.13).
# H1: p > 0.13.
# IMPORTANTE: bajo H0 el EE usa p_referencia, NO p_muestral.
ee_h0 <- sqrt(p_referencia * (1 - p_referencia) / n)
z_observado <- (p_muestral - p_referencia) / ee_h0
p_valor <- pnorm(z_observado, lower.tail = FALSE)
rechazar_h0 <- p_valor < alpha

# Verificación de la aproximación normal en H0
np0 <- n * p_referencia
nq0 <- n * (1 - p_referencia)
stopifnot(np0 >= 10, nq0 >= 10)

# 5. Comprobación adicional: prueba binomial exacta
# Su valor p puede diferir un poco del aproximado (z).
prueba_exacta <- binom.test(morosos, n, p = p_referencia,
                           alternative = 'greater')

cat('\nPROYECTO 03 | MOROSIDAD DE PRÉSTAMOS PERSONALES\n')
cat(sprintf('Muestra: %d clientes | Morosos: %d | No morosos: %d\n',
            n, morosos, no_morosos))
cat(sprintf('Morosidad observada: %.2f%% | Referencia: %.2f%%\n',
            100 * p_muestral, 100 * p_referencia))
cat(sprintf('Diferencia: +%.2f puntos porcentuales\n', diferencia_pp))
cat(sprintf('IC clásico del 95%%: [%.2f%%, %.2f%%]\n',
            100 * ic_clasico[1], 100 * ic_clasico[2]))
cat(sprintf('Prueba z unilateral: z = %.4f; valor p = %.6f\n',
            z_observado, p_valor))
cat(sprintf('Prueba binomial exacta (comprobación): valor p = %.6f\n',
            prueba_exacta$p.value))
cat(if (rechazar_h0)
      'Decisión: rechazar H0 al 5%; evidencia de morosidad superior al 13%.\n'
    else
      'Decisión: no rechazar H0 al 5%%.\n')

# 6. Bootstrap percentil (B = 1,000), siguiendo el laboratorio.
# Se reconstruyen 400 observaciones binarias a partir de los conteos
# originales: 1 = cliente moroso, 0 = cliente no moroso.
# No son clientes adicionales ni datos individuales nuevos.
datos_morosidad <- c(rep(1, morosos), rep(0, no_morosos))
B <- 1000
set.seed(123)
proporciones_boot <- replicate(
  B, mean(sample(datos_morosidad, size = n, replace = TRUE))
)
ic_boot <- as.numeric(quantile(proporciones_boot,
                                probs = c(alpha / 2, 1 - alpha / 2)))
cat(sprintf('IC bootstrap percentil, B=%d: [%.2f%%, %.2f%%]\n',
            B, 100 * ic_boot[1], 100 * ic_boot[2]))
cat('Nota: Bootstrap refleja el remuestreo de esta muestra; no corrige sesgo de selección.\n')

# 7. Gráfico: proporción, IC clásico y referencia
if (!dir.exists('figuras')) dir.create('figuras')
png('figuras/intervalo-proporcion.png', width = 1400, height = 720, res = 160)
par(mar = c(5.5, 3, 2.0, 2), family = 'sans')
plot(NA, xlim = c(0.095, 0.235), ylim = c(0.45, 1.65),
     xlab = 'Proporción de clientes morosos (%)', ylab = '',
     axes = FALSE, frame.plot = FALSE)
abline(v = seq(10, 23, 1) / 100, col = '#E6EEF2', lwd = 1)
abline(v = p_referencia, col = '#C88743', lwd = 3, lty = 2)
segments(ic_clasico[1], 1, ic_clasico[2], 1,
         col = '#008E91', lwd = 9, lend = 'round')
points(p_muestral, 1, col = '#163A50', pch = 19, cex = 2.0)
axis(1, at = seq(10, 23, 2) / 100, labels = paste0(seq(10, 23, 2), '%'),
     col = '#CEDADF', col.axis = '#35586A')
text(p_referencia, 1.45, 'Referencia: 13%', col = '#A56B32', pos = 4, cex = .95)
text(p_muestral, 1.25, '17% en la muestra', col = '#163A50', cex = 1.0)
text(mean(ic_clasico), .70,
     sprintf('IC 95%%: %.2f%% - %.2f%%', 100*ic_clasico[1], 100*ic_clasico[2]),
     col = '#007F86', cex = .92)
dev.off()

# Comprobación de valores principales del ejercicio
stopifnot(abs(p_muestral - .17) < 1e-12,
          abs(z_observado - 2.3788041338) < 1e-8,
          abs(p_valor - .0086844511) < 1e-8)
