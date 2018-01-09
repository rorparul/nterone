angular
  .module 'nterone'
  .directive 'radialprogressChart', ()->
    templateUrl: 'directives/charts/radialprogress-chart.html'
    scope: {}
    link: (scope, element, attrs)->
      chartElement = element.find('.chart')
      data = attrs.value
      scope.caption = attrs.caption
      scope.amount = attrs.amount
      scope.goal = attrs.goal

      viz = vizuly.viz.radial_progress(chartElement[0])
      theme = vizuly.theme.radial_progress(viz).skin(vizuly.skin.RADIAL_PROGRESS_ALERT)

      viz
        .data(data)
        .height(300)
        .min(0)
        .max(100)
        .capRadius(25)
        .startAngle(250)
        .endAngle(110)
        .arcThickness(.12)
        .label (d,i)->
          d3.format(".0f")(d) + "%"
        .update()

      selection = viz.selection()

      selection.selectAll(".vz-radial_progress-label")
        .style("fill", "#000")
        .style("stroke-opacity", 0)
        .style("font-size", viz.radius() *.25)

      selection.selectAll(".vz-radial_progress-track")
          .style("fill", "#BBB");
