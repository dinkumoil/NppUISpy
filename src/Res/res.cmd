@pushd "%~dp0"

call "Images\images.cmd"
@echo.

@if /i "%~1" neq "/s" pause

@popd
