library(shiny)
library(DT)

shinyServer(function(input, output, session) {
  
  output$gene_expression_plot <- renderPlot({
    req(input$search_gene)
    gene_data <- circadian_clean %>%
      filter(Gene == input$search_gene)
    
    ggplot(gene_data, aes(x = Diet, y = MaxExpr, fill = Age)) +
      geom_bar(stat = "identity", position = "dodge") +
      facet_wrap(~ Diet, scales = "free_y") +
      labs(title = paste("Circadian Expression of", input$search_gene),
           y = "Max RPKM", x = "Condition") +
      theme_minimal(base_size = 14) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  output$aging_table <- DT::renderDT({
    req(input$search_gene)
    raw_row <- aging_clean %>% filter(Gene == input$search_gene)
    
    fc_cols <- grep("^log2FoldChange", names(raw_row), value = TRUE)
    padj_cols <- grep("^padj", names(raw_row), value = TRUE)
    
    aging_summary <- data.frame(
      Condition = gsub("^log2FoldChange\\.", "", fc_cols),
      log2FoldChange = as.numeric(raw_row[1, fc_cols]),
      padj = as.numeric(raw_row[1, padj_cols])
    ) %>%
      mutate(Significant = ifelse(padj < 0.05, "Yes", "No"))
    
    DT::datatable(aging_summary, rownames = FALSE, options = list(pageLength = 10))
  })
  
  
  output$circadian_plot <- renderPlot({
    req(input$search_gene)
    plot_data <- cycling_long %>% filter(Gene == input$search_gene)
    
    ggplot(plot_data, aes(x = Hour, y = Expression, color = Rep, group = Rep)) +
      geom_line(size = 1.2) +
      facet_wrap(~ Group) +
      labs(title = paste("Circadian Time-Course for", input$search_gene),
           x = "Time (hours)", y = "Expression (RPKM)") +
      theme_minimal(base_size = 14)
  })
  
  output$multi_condition_plot <- renderPlot({
    req(input$search_gene)
    gene_data <- cycling_long %>%
      filter(Gene == input$search_gene) %>%
      group_by(ConditionGroup, Age, Gene, Hour) %>%
      summarise(Expression = mean(Expression, na.rm = TRUE), .groups = "drop")
    
    ggplot(gene_data, aes(x = Hour, y = Expression, color = ConditionGroup, group = interaction(Age, ConditionGroup))) +
      geom_line(size = 1.2) +
      facet_wrap(~ Age) +
      scale_color_manual(values = condition_colors) +
      labs(title = paste("Condensed Circadian Expression of", input$search_gene),
           y = "Mean RPKM", x = "Time (h)", color = "Condition") +
      theme_minimal(base_size = 14) +
      theme(legend.position = "bottom")
  })
  
  output$gene_info <- DT::renderDT({
    req(input$search_gene)
    gene_info_table <- gene_info %>%
      filter(GeneSymbol == input$search_gene) %>%
      select(GeneID, Chr, Start, End, Strand, Length, GeneSymbol, EnsID, EnsID_short) %>%
      distinct() %>%
      mutate(Ensembl_Link = paste0("<a href='https://useast.ensembl.org/Mus_musculus/Gene/Summary?g=", EnsID_short, "' target='_blank'>", EnsID_short, "</a>"))
    
    DT::datatable(gene_info_table, escape = FALSE, options = list(pageLength = 5))
  })
  
  
})
