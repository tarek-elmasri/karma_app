module Testable extend ActiveSupport::Concern

  module ClassMethods
    def where_last_order_since(date=1.month.ago)
      recent_invoices = Invoice.arel_table
      .project(Invoice.arel_table[:client_id].as("recent_client_id"))
      .where(Invoice.arel_table[:date].gt(date))
      .as("recent_invoices")

      joins(
        arel_table
        .join(recent_invoices, Arel::Nodes::OuterJoin)
        .on(arel_table[:id].eq(recent_invoices[:recent_client_id]))
        .join_sources
      )
      .left_joins(:invoices)
      .where(
        recent_invoices[:recent_client_id]
        .eq(nil)
        .and(
          Invoice.arel_table[:date].lt(date)
          .or(Invoice.arel_table[:date].eq(nil))
          )
        )
      .distinct
    end


  end

end


    # def filter_by_last_order_since(months=1.month.ago)
    #   old_invoices = Invoice.arel_table
    #   .project(Invoice.arel_table[:client_id].as("old_client_id"))
    #   .where(Invoice.arel_table[:date].lt(months))
    #   .as("old_invoices")

    #   recent_invoices = Invoice.arel_table
    #   .project(Invoice.arel_table[:client_id].as("recent_client_id"))
    #   .where(Invoice.arel_table[:date].gt(months))
    #   .as("recent_invoices")

    #   joins(
    #     arel_table
    #     .join(old_invoices)
    #     .on(arel_table[:id].eq(old_invoices[:old_client_id]))
    #     .join_sources
    #   ).joins(
    #     arel_table
    #     .join(recent_invoices, Arel::Nodes::OuterJoin)
    #     .on(arel_table[:id].eq(recent_invoices[:recent_client_id]))
    #     .join_sources
    #   )
    #   .where(recent_invoices[:recent_client_id].eq(nil))
    #   .group(:id)
    # end
