$ ->

  # Le moyen privilégié de récupération des évènements de mise à jour est l'API EventSource
  if typeof EventSource != "undefined"

    # Navigateur compatible, récupération des évènements par EventSource
    download_events = new EventSource "/raindrops/downloads/events"

    # Gestion des évènements de mise à jour des statuts de progression des téléchargements
    download_events.addEventListener "download-progress", (e) ->
      download = JSON.parse e.data
      $(".progress-bar", "#download-" + download.id).css "width", download.progress + "%"
      $(".progress-bar > span", "#download-" + download.id).text download.progress + "%"
      $(".download-status", "#download-" + download.id).text download.bytes_downloaded_human + " / " + download.file_size_human

    # Gestion des évènements d'ajout d'un nouveau téléchargement
    download_events.addEventListener "download-created", (e) ->
      download = JSON.parse e.data
      download_table = document.querySelector "table.downloads > tbody"
      download_template = document.querySelector "#template-download"
      download_template.content.querySelector("tr").id = "download-" + download.id
      download_tds = download_template.content.querySelectorAll "td"
      download_tds[0].textContent = download.source_url.split("/").pop()
      download_tds[2].textContent = '0 / ' + download.file_size_human
      download_table.appendChild download_template.content.cloneNode(true)

    # Gestion des évènements d'effacement d'un téléchargement
    download_events.addEventListener "download-destroyed", (e) ->
      download = JSON.parse e.data
      $("#download-" + download.id).remove()

    # Gestion des évènements de complétion d'un téléchargement
    download_events.addEventListener "download-completed", (e) ->
      download = JSON.parse e.data
      $("#download-" + download.id).addClass "success"

  else
    # TODO: Ajax pooling ?