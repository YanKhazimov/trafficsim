cmake_minimum_required(VERSION 2.8.12)

project(TrafficSimulator LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 COMPONENTS Core Quick REQUIRED)

set(SOURCE_FILES
    "RegularCrossroad.cpp"
    "CrossroadSide.cpp"
    "QmlPresenter.cpp"
    "Lane.cpp"
    "CrossroadSidesModel.cpp"
    "Car.cpp"
    "Passage.cpp"
    "CrossroadPassagesModel.cpp"
    "CarsModel.cpp"
    "MapGraph.cpp"
    "NodesModel.cpp"
    "Node.cpp"
    "RoadLane.cpp"
    "RoadLanesModel.cpp"
    "Curve.cpp"
    "DataRoles.h"
    "RegularCrossroad.h"
    "CrossroadSide.h"
    "QmlPresenter.h"
    "Lane.h"
    "CrossroadSidesModel.h"
    "Car.h"
    "Passage.h"
    "CrossroadPassagesModel.h"
    "CarsModel.h"
    "MapGraph.h"
    "NodesModel.h"
    "Node.h"
    "RoadLane.h"
    "RoadLanesModel.h"
    "Curve.h"
    )

add_executable(${PROJECT_NAME} "main.cpp" ${SOURCE_FILES} "resources/qml.qrc")

target_link_libraries(${PROJECT_NAME} Qt5::Core Qt5::Quick)
