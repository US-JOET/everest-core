#/usr/bin/env bash
set -e

main() {
    local delete_existing_build=false
    local run_cmake=false

    for key in "$@"; do
        case $key in
            --clean)
                delete_existing_build=true
                run_cmake=true
                shift
                ;;
            --cmake)
                run_cmake=true
                shift
                ;;
            *)
                echo "Unknown option $i"
                exit 1
                ;;
        esac
    done

    (
        cd /workspaces/everest-utils/everest-cpp/everest-core

        if [ "${delete_existing_build}" = true ]; then
            echo 'Deleting existing build(s)'
            rm -rf /workspaces/everest-utils/everest-cpp/everest-core/build/*
        fi

        if [ "${run_cmake}" = true ]; then
            echo 'Running CMake'
            cmake \
                -B build \
                -G Ninja \
                -DEVC_ENABLE_CCACHE=1 \
                -DISO15118_2_GENERATE_AND_INSTALL_CERTIFICATES=OFF \
                -DCMAKE_INSTALL_PREFIX="build/dist" \
                -DBUILD_TESTING=ON
        fi

        echo 'Running Ninja'
        ninja -j$(nproc) -C build
    )
}

if [ "${BASH_SOURCE}" = "$0" ]; then
    main "$@"
fi