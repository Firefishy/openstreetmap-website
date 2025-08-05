#!/bin/bash
export GD2_LIBRARY_PATH=$(pkgconf --variable=libdir gdlib)
echo "GD2_LIBRARY_PATH=$GD2_LIBRARY_PATH"
exec "$@"
