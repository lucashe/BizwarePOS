module ReportsHelper
  
  def get_sales(scope, startDate, endDate)

    if scope == :store
    sales_scope = @current_store
    elsif scope == :branch
    sales_scope = @current_branch
    else
      sales_scope = current_user
    end

    if (not startDate.blank?) && endDate.blank?
      sales = sales_scope.sales.where('sales.created_at >= ?',startDate)
    elsif startDate.blank? && (not endDate.blank?)
      sales = sales_scope.sales.where('sales.created_at <= ?',endDate)
    elsif  (not startDate.blank?) && (not endDate.blank?)
      sales = sales_scope.sales.where('sales.created_at >= ? AND sales.created_at <= ?',startDate, endDate)
    else
    sales = sales_scope.sales.all
    end

  end

  def get_payments(scope, startDate, endDate)

    if scope == :store
    payments_scope = @current_store
    elsif scope == :branch
    payments_scope = @current_branch
    else
      payments_scope = current_user
    end

    if (not startDate.blank?) && endDate.blank?
      payments = payments_scope.payments.where('payments.created_at >= ?',startDate)
    elsif startDate.blank? && (not endDate.blank?)
      payments = payments_scope.payments.where('payments.created_at <= ?',endDate)
    elsif  (not startDate.blank?) && (not endDate.blank?)
      payments = payments_scope.payments.where('payments.created_at >= ? AND sales.created_at <= ?',startDate, endDate)
    else
    payments = payments_scope.payments.all
    end

  end

  def get_sales_total(scope, startDate, endDate)

    sales = get_sales(scope, startDate, endDate)

    sales_total = 0.00
    for sale in sales
      unless sale.total_amount.blank?
      sales_total += sale.total_amount
      end
    end
    return sales_total
  end

  def get_sales_cost(scope, startDate, endDate)

    sales = get_sales(scope, startDate, endDate)

    sales_cost_total = 0.00
    for sale in sales
      unless sale.cost.blank?
      sales_cost_total += sale.cost
      end
    end
    return sales_cost_total
  end

  def get_sales_count(scope, startDate, endDate)

    sales = get_sales(scope, startDate, endDate)
    return sales.count

  end

  def get_payments_total(scope, startDate, endDate)

    payments = get_payments(scope, startDate, endDate)

    payments_total = 0.00
    for payment in payments
      unless payment.amount.blank?
      payments_total +=  payment.amount_after_change
      end
    end
    return payments_total
  end

  def get_owed_balance(scope, startDate, endDate)
    return (get_sales_total(scope, startDate, endDate) - get_payments_total(scope, startDate, endDate))
  end

  def get_sales_profit(scope, startDate, endDate)
    return (get_sales_total(scope, startDate, endDate) - get_sales_cost(scope, startDate, endDate))
  end

  #
  # Get sales amount for different time periods
  #
  def sales_today(scope)
    get_sales_total(scope,Time.zone.now.beginning_of_day,nil)
  end

  def sales_week(scope)
    get_sales_total(scope,Time.zone.now.beginning_of_week,nil)
  end

  def sales_month(scope)
    get_sales_total(scope,Time.zone.now.beginning_of_month,nil)
  end

  def sales_quarter(scope)
    get_sales_total(scope,Time.zone.now.beginning_of_quarter,nil)
  end

  def sales_year(scope)
    get_sales_total(scope,Time.zone.now.beginning_of_year,nil)
  end

  #
  # Get sales count for different time periods
  #
  def sales_count_today(scope)
    get_sales_count(scope,Time.zone.now.beginning_of_day,nil)
  end

  def sales_count_week(scope)
    get_sales_count(scope,Time.zone.now.beginning_of_week,nil)
  end

  def sales_count_month(scope)
    get_sales_count(scope,Time.zone.now.beginning_of_month,nil)
  end

  def sales_count_quarter(scope)
    get_sales_count(scope,Time.zone.now.beginning_of_quarter,nil)
  end

  def sales_count_year(scope)
    get_sales_count(scope,Time.zone.now.beginning_of_year,nil)
  end

  #
  # Get cost for different time periods
  #
  def sales_cost_today(scope)
    get_sales_cost(scope,Time.zone.now.beginning_of_day,nil)
  end

  def sales_cost_week(scope)
    get_sales_cost(scope,Time.zone.now.beginning_of_week,nil)
  end

  def sales_cost_month(scope)
    get_sales_cost(scope,Time.zone.now.beginning_of_month,nil)
  end

  def sales_cost_quarter(scope)
    get_sales_cost(scope,Time.zone.now.beginning_of_quarter,nil)
  end

  def sales_cost_year(scope)
    get_sales_cost(scope,Time.zone.now.beginning_of_year,nil)
  end

  #
  # Get profit for different time periods
  #
  def sales_profit_today(scope)
    get_sales_profit(scope,Time.zone.now.beginning_of_day,nil)
  end

  def sales_profit_week(scope)
    get_sales_profit(scope,Time.zone.now.beginning_of_week,nil)
  end

  def sales_profit_month(scope)
    get_sales_profit(scope,Time.zone.now.beginning_of_month,nil)
  end

  def sales_profit_quarter(scope)
    get_sales_profit(scope,Time.zone.now.beginning_of_quarter,nil)
  end

  def sales_profit_year(scope)
    get_sales_profit(scope,Time.zone.now.beginning_of_year,nil)
  end

end
