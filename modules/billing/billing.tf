resource "aws_budgets_budget" "budget-1" {
  provider      = aws.cuenta_root
  // Nombre del budget
  name          = "BGT-AWS-${upper(replace(var.cliente,"-","_"))}"
  // Monto maximo a consumir 
  limit_amount  = "200.0"
  // Moneda en que se evaluara el budget
  limit_unit    = "USD"
  // Tipo de budget
  budget_type   = "COST"
  cost_filter {
      name    = "LinkedAccount"
      // Cuenta a la que se realizarán las validaciones de consumo
      values  = [var.id_cuenta_local]
  }
  cost_types {
      include_credit              = false
      include_discount            = true
      include_other_subscription  = true
      include_recurring           = true
      include_refund              = false
      include_subscription        = true
      include_support             = true
      include_tax                 = true
      include_upfront             = true
      use_amortized               = false
      use_blended                 = false
  }
  notification {
      comparison_operator         = "GREATER_THAN"
      notification_type           = "ACTUAL"
      // Correo al que se enviarán las notificaciones de consumo
      subscriber_email_addresses  = [var.alerts_email]
      // Tope de porcentaje maximo para realizar una notificacion
      threshold                   = 95
      threshold_type              = "PERCENTAGE"
  }
  // Unidad de medida para el budget
  time_unit = "MONTHLY"
}