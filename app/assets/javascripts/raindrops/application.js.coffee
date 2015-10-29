$ ->

  # Le moyen privilégié de récupération des évènements de mise à jour est l'API EventSource
  if typeof(EventSource) != "undefined"

    # Navigateur compatible, récupération des évènements par EventSource
    download_events = new EventSource "/raindrops/downloads/events"

    # Gestion des évènements de mise à jour des statuts de progression des téléchargements
    download_events.addEventListener "download-progress", (e) ->
      download = JSON.parse e.data
      $(".progress-bar", "#download-" + download.id).css "width", download.progress + "%"
      $(".progress-bar > span", "#download-" + download.id).text download.progress + "%"
      undefined

    # Gestion des évènements d'ajout d'un nouveau téléchargement
    download_events.addEventListener "download-new", (e) ->
      download = JSON.parse e.data
      console.info download

  else
    # TODO: Ajax pooling