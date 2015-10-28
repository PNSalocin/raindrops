$ ->
  if typeof(EventSource) != "undefined"
    download_progress_source = new EventSource "/raindrops/downloads/progress"
    download_progress_source.addEventListener "downloads-progress", (e) ->
      download = JSON.parse e.data
      $(".progress-bar", "#download-" + download.id).css "width", download.progress + "%"
      $(".progress-bar > span", "#download-" + download.id).text download.progress + "%"
      undefined
  else
  # TODO: Ajax pooling