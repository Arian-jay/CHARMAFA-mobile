double computeBill(double consumption) {
  double bill = 0.0;
  double remaining = consumption;

  if (remaining <= 0) return 0.0;

  double step1 = remaining.clamp(0, 10);
  bill += step1 * 5.0;
  remaining -= step1;

  if (remaining > 0) {
    double step2 = remaining.clamp(0, 20);
    bill += step2 * 7.0;
    remaining -= step2;
  }

  if (remaining > 0) {
    bill += remaining * 10.0;
  }

  bill += 15.0; // service fee
  return bill;
}
