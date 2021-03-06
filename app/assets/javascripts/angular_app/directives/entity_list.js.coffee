angular.module('InescApp').directive 'entityList', ['routing', (routing) ->
  columns = [
    { sTitle: 'Órgão', bVisible: false },
    { sTitle: 'Unidades Orçamentárias (agrupadas por órgão)', bSortable: false }
  ]

  options =
    aaSorting: [[0, 'asc'], [1, 'asc']]
    fnDrawCallback: (oSettings) ->
      return if oSettings.aiDisplay.length == 0
      nTrs = $(oSettings.nTBody.children)
      sLastGroup = ''

      for tr, i in nTrs
        iDisplayIndex = oSettings._iDisplayStart + i
        sGroup = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData[0]
        if sGroup != sLastGroup
          nGroup = document.createElement('tr')
          nGroup.className = 'entity-group'
          nCell = document.createElement('td')
          nCell.innerHTML = sGroup
          nGroup.appendChild(nCell)
          tr.parentNode.insertBefore(nGroup, tr)
          sLastGroup = sGroup

  processData = (entities, year) ->
    entities.filter((entity) -> entity.orgao?)
      .map (uo) ->
        orgao = uo.orgao
        orgaoUrl = routing.generateUrl(orgao, year)
        uoUrl = routing.generateUrl(uo, year)
        ["<a href='#{orgaoUrl}'>#{orgao.label}</a>",
         "<a href='#{uoUrl}'>#{uo.label}</a>"]

  restrict: 'E',
  template: '<my-data-table class="entity-list" columns="columns" options="options" data="data"></my-data-table>',
  scope:
    entities: '='
    year: '='
  link: (scope, element, attributes) ->
    scope.columns = columns
    scope.options = options
    scope.$watch 'entities + year', ->
      [entities, year] = [scope.entities, scope.year]
      if entities && year
        scope.data = processData(entities, year)
]

