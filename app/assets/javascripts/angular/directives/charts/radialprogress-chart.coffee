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

      skinA =
        name: "Alert"
        label_color: "#CCC"
        track_fill: "#DDDDDD"
        progress_colors: ["#4CAF50", "#FFC107", "#FF9800", "#E64A19", "#FFEB3B"]
        arc_fill: (d, i)->
            this.progress_colors[i % 5]
        arc_fill_opacity: (d,i)->
            1
        arc_stroke: (d, i)->
            this.progress_colors[i % 5]
        class: "vz-skin-alert"

      viz = vizuly.viz.radial_progress(chartElement[0])
      theme = vizuly.theme.radial_progress(viz).skin(vizuly.skin.RADIAL_PROGRESS_ALERT)
      theme.skin().arc_fill = (d, i)->
        value = viz.data()
        if value < 40
          "#E64A19"
        else if value < 90
          "#FFC107"
        else
          "#4CAF50"

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
          .style("fill", "#BBB")
