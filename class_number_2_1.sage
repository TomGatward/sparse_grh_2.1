from math import sqrt, log, exp
from sage.all import Integer, QuadraticField, RealNumber

# Parameters
max_D = 40000

# Initialize result lists
results_D = []
results_h = []
results_simple_bound = []
results_original_bound = []
results_simple_ratio = []
results_original_ratio = []

# Violation counters
simple_violations = 0
original_violations = 0
count = 0

for Δ in range(-max_D, max_D + 1):
    Δ = Integer(Δ)
    if Δ == 0 or not Δ.is_fundamental_discriminant():
        continue

    try:
        K = QuadraticField(Δ)
        h = K.class_number()
    except Exception:
        continue

    log_term = log(abs(Δ))
    sqrt_log_term = sqrt(log_term)

    # Two bounds
    simple_bound = 26.7 * sqrt(abs(Δ)) * (log_term**(-1.18))
    bach_bound = RealNumber('1.13') * sqrt(abs(Δ)) * log(abs(Δ))

    # Store results
    results_D.append(int(Δ))
    results_h.append(h)
    results_simple_bound.append(float(simple_bound))
    results_original_bound.append(float(bach_bound))
    results_simple_ratio.append(h / simple_bound)
    results_original_ratio.append(h / bach_bound)

    # Count violations
    if h > simple_bound:
        simple_violations += 1
    if h > bach_bound:
        original_violations += 1

    count += 1
    if count % 100 == 0:
        print(f"{count} fields processed")

# Summary
print(f"\nRESULTS FOR DISCRIMINANTS |Δ| ≤ {max_D}")
print("=" * 40)
print(f"Total fields tested: {count}\n")

print("SIMPLIFIED BOUND:")
print(f"Violations: {simple_violations} ({round(100 * simple_violations / count, 2)}%)\n")

print("BACH BOUND:")
print(f"Violations: {original_violations} ({round(100 * original_violations / count, 2)}%)\n")

# Compare averages and which bound is tighter
avg_simple = sum(results_simple_ratio) / count
avg_bach = sum(results_original_ratio) / count
your_better = sum(1 for y, b in zip(results_simple_ratio, results_original_ratio) if y > b)

print(f"Average Ratio h/YourBound: {avg_simple:.3f}")
print(f"Average Ratio h/BachBound: {avg_bach:.3f}")
print(f"Cases where Your Bound is Closer: {your_better} of {count}")