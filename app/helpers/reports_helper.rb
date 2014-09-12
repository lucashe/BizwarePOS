module ReportsHelper
  def get_sales(scope)
    if scope == :store
      sales = @current_store.sales.find(:all)
    elsif scope == :branch
      sales = @current_branch.sales.find(:all)
    else
      sales = current_user.sales.find(:all)
    end

  end

  def get_payments(scope)
    if scope == :store
      payments = @current_store.payments.find(:all)
    elsif scope == :branch
      payments = @current_branch.payments.find(:all)
    else
      payments = current_user.payments.find(:all)
    end
  end

  def raw_sales(scope)

    sales = get_sales(scope)

    total = 0.00
    for sale in sales
      unless sale.total_amount.blank?
      total += sale.total_amount
      end
    end
    return total
  end

  def payment_total(scope)

    payments = get_payments(scope)

    payment_total = 0.00
    for payment in payments
      payment_total += payment.amount.blank? ? 0.00 : payment.amount_after_change
    end
    return payment_total
  end

  def owed_balance(scope)
    raw_sales(scope) - payment_total(scope)
  end

  def sales_today(scope)

    total = 0.00
    sales = get_sales(scope).select {|s| s.created_at >= Time.zone.now.beginning_of_day}

    for sale in sales
      unless sale.total_amount.blank?
      total += sale.total_amount
      end
    end
    return total
  end

end
