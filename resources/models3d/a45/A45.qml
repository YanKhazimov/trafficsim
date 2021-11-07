import QtQuick 2.15
import QtQuick3D 1.15

Node {
    id: a45_obj

    property alias metalness: material_004_material.metalness
    property alias roughness: material_004_material.roughness
    property alias color: material_004_material.baseColor

    scale: Qt.vector3d(15, 15, 15)
    y: -104

/*    property var meshes: [
    circle_003_Circle_004,
    circle_004_Circle_005,
    circle_005_Circle_006,
    circle_007_Circle_012,
    circle_008_Circle_011,
    cylinder_Cylinder_001,
    cube_028_Cube_029,
    screen_wipers_Cube_002,
    screen_wipers_Cube_002,
    cylinder_001_Cylinder,
    cube_036_Cube_004,
    cube_001_Cube_014,
    cube_003,
    cube_010_Cube_005,
    cube_015_Cube_017,
    cube_014_Cube_020,
    cube_016_Cube_018,
    cube_019_Cube_024,
    cube_004_Cube_026,
    cube_Cube_006,
    tIRE1_Circle_003,
    cube_020_Cube_001,
    cube_023_Cube_022,
    node1_Cube_027,
    cube_025_Cube_033,
    cube_026_Cube_015,
    cube_027_Cube_023,
    plane_001,
    cube_029_Cube_031,
    cube_031_Cube,
    cube_032_Cube_030,
    cube_033_Cube_034,
    cube_035_Cube_036,
    cube_039_Cube_038,
    cube_038_Cube_043,
    cube_041_Cube_049,
    cube_040_Cube_051,
    cube_043_Cube_052,
    cube_044_Cube_037,
    cube_034_Cube_035,
    plane,
    cube_021_Cube_039,
    plane_003,
    tIRE1_001_Circle_013,
    tIRE1_002_Circle_015,
    tIRE1_003_Circle_016,
    cube_002_Cube_012,
    cube_062_Cube_064,
    circle_006_Circle_010,
    cube_009_Cube_011,
    cube_045_Cube_025,
    cube_047_Cube_041,
    circle_009_Circle_014,
    plane_004,
    ]

    Model {
        id: circle_003_Circle_004
        source: "meshes/circle_003_Circle_004.mesh"

        DefaultMaterial {
            id: material_014_material
            diffuseColor: "#ff999999"
        }

        DefaultMaterial {
            id: material_material
            diffuseColor: "#ff111111"
        }
        materials: [
            material_014_material,
            material_material
        ]
    }

    Model {
        id: circle_004_Circle_005
        source: "meshes/circle_004_Circle_005.mesh"
        materials: [
            material_014_material,
            material_material
        ]
    }

    Model {
        id: circle_005_Circle_006
        source: "meshes/circle_005_Circle_006.mesh"

        DefaultMaterial {
            id: material_007_material
            diffuseColor: "#ff999999"
        }
        materials: [
            material_007_material
        ]
    }

    Model {
        id: circle_007_Circle_012
        source: "meshes/circle_007_Circle_012.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: circle_008_Circle_011
        source: "meshes/circle_008_Circle_011.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: cylinder_Cylinder_001
        source: "meshes/cylinder_Cylinder_001.mesh"

        DefaultMaterial {
            id: material_002_material
            diffuseColor: "#ffaaaaaa"
        }
        materials: [
            material_002_material
        ]
    }

    Model {
        id: cube_028_Cube_029
        source: "meshes/cube_028_Cube_029.mesh"

        DefaultMaterial {
            id: material_031_material
            diffuseColor: "#ff999999"
        }
        materials: [
            material_031_material
        ]
    }

    Model {
        id: screen_wipers_Cube_002
        source: "meshes/screen_wipers_Cube_002.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: cylinder_001_Cylinder
        source: "meshes/cylinder_001_Cylinder.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: cube_036_Cube_004
        source: "meshes/cube_036_Cube_004.mesh"

        DefaultMaterial {
            id: material_036_material
            diffuseColor: "#ff999999"
        }
        materials: [
            material_material,
            material_036_material
        ]
    }

    Model {
        id: cube_001_Cube_014
        source: "meshes/cube_001_Cube_014.mesh"

        DefaultMaterial {
            id: material_037_material
            diffuseColor: "#ff999999"
        }
        materials: [
            material_037_material,
            material_036_material
        ]
    }

    Model {
        id: cube_003
        source: "meshes/cube_003.mesh"

        DefaultMaterial {
            id: material_019_material
            diffuseColor: "#ff999999"
        }
        materials: [
            material_019_material
        ]
    }

    Model {
        id: cube_010_Cube_005
        source: "meshes/cube_010_Cube_005.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: cube_015_Cube_017
        source: "meshes/cube_015_Cube_017.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: cube_014_Cube_020
        source: "meshes/cube_014_Cube_020.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: cube_016_Cube_018
        source: "meshes/cube_016_Cube_018.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: cube_019_Cube_024
        source: "meshes/cube_019_Cube_024.mesh"

        DefaultMaterial {
            id: material_022_material
            diffuseColor: "#ff999999"
        }
        materials: [
            material_007_material,
            material_022_material
        ]
    }

    Model {
        id: cube_004_Cube_026
        source: "meshes/cube_004_Cube_026.mesh"

        DefaultMaterial {
            id: material_011_material
            diffuseColor: "#ff999999"
        }

        DefaultMaterial {
            id: material_016_material
            diffuseColor: "#ff999999"
        }
        materials: [
            material_material,
            material_011_material,
            material_016_material
        ]
    }

    Model {
        id: cube_Cube_006
        source: "meshes/cube_Cube_006.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: tIRE1_Circle_003
        source: "meshes/tIRE1_Circle_003.mesh"

        DefaultMaterial {
            id: material_025_material
            diffuseColor: "#ff999999"
        }

        DefaultMaterial {
            id: material_017_material
            diffuseColor: "#ff999999"
        }
        materials: [
            material_material,
            material_014_material,
            material_025_material,
            material_017_material
        ]
    }

    Model {
        id: cube_020_Cube_001
        source: "meshes/cube_020_Cube_001.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: cube_023_Cube_022
        source: "meshes/cube_023_Cube_022.mesh"

        DefaultMaterial {
            id: material_012_material
            diffuseColor: "#ff999999"
        }
        materials: [
            material_011_material,
            material_012_material
        ]
    }

    Model {
        id: node1_Cube_027
        source: "meshes/node1_Cube_027.mesh"
        materials: [
            material_002_material
        ]
    }

    Model {
        id: cube_025_Cube_033
        source: "meshes/cube_025_Cube_033.mesh"
        materials: [
            material_material,
            material_014_material
        ]
    }

    Model {
        id: cube_026_Cube_015
        source: "meshes/cube_026_Cube_015.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: cube_027_Cube_023
        source: "meshes/cube_027_Cube_023.mesh"

        DefaultMaterial {
            id: material_008_material
            diffuseColor: "#ff999999"
        }

        DefaultMaterial {
            id: material_013_material
            diffuseColor: "#ff999999"
        }

        DefaultMaterial {
            id: material_021_material
            diffuseColor: "#ff999999"
        }
        materials: [
            material_008_material,
            material_013_material,
            material_021_material
        ]
    }

    Model {
        id: plane_001
        source: "meshes/plane_001.mesh"
        materials: [
            material_016_material
        ]
    }

    Model {
        id: cube_029_Cube_031
        source: "meshes/cube_029_Cube_031.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: cube_031_Cube
        source: "meshes/cube_031_Cube.mesh"
        materials: [
            material_008_material
        ]
    }

    Model {
        id: cube_032_Cube_030
        source: "meshes/cube_032_Cube_030.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: cube_033_Cube_034
        source: "meshes/cube_033_Cube_034.mesh"
        materials: [
            material_007_material,
            material_material,
            material_014_material,
            material_016_material
        ]
    }

    Model {
        id: cube_035_Cube_036
        source: "meshes/cube_035_Cube_036.mesh"

        DefaultMaterial {
            id: material_009_material
            diffuseColor: "#ff999999"
        }
        materials: [
            material_material,
            material_014_material,
            material_009_material
        ]
    }

    Model {
        id: cube_039_Cube_038
        source: "meshes/cube_039_Cube_038.mesh"

        DefaultMaterial {
            id: material_032_material
            diffuseColor: "#ff999999"
        }
        materials: [
            material_material,
            material_032_material
        ]
    }

    Model {
        id: cube_038_Cube_043
        source: "meshes/cube_038_Cube_043.mesh"
        materials: [
            material_007_material
        ]
    }

    Model {
        id: cube_041_Cube_049
        source: "meshes/cube_041_Cube_049.mesh"
        materials: [
            material_material,
            material_014_material
        ]
    }

    Model {
        id: cube_040_Cube_051
        source: "meshes/cube_040_Cube_051.mesh"
        materials: [
            material_014_material
        ]
    }

    Model {
        id: cube_043_Cube_052
        source: "meshes/cube_043_Cube_052.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: cube_044_Cube_037
        source: "meshes/cube_044_Cube_037.mesh"
        materials: [
            material_007_material
        ]
    }

    Model {
        id: cube_034_Cube_035
        source: "meshes/cube_034_Cube_035.mesh"
        materials: [
            material_007_material,
            material_022_material
        ]
    }

    Model {
        id: plane
        source: "meshes/plane.mesh"

        DefaultMaterial {
            id: material_029_material
            diffuseColor: "#ff999999"
        }
        materials: [
            material_029_material
        ]
    }

    Model {
        id: cube_021_Cube_039
        source: "meshes/cube_021_Cube_039.mesh"
        materials: [
            material_014_material
        ]
    }

    Model {
        id: plane_003
        source: "meshes/plane_003.mesh"
        materials: [
            material_029_material
        ]
    }

    Model {
        id: tIRE1_001_Circle_013
        source: "meshes/tIRE1_001_Circle_013.mesh"
        materials: [
            material_material,
            material_014_material,
            material_025_material,
            material_017_material
        ]
    }

    Model {
        id: tIRE1_002_Circle_015
        source: "meshes/tIRE1_002_Circle_015.mesh"
        materials: [
            material_material,
            material_014_material,
            material_025_material,
            material_017_material
        ]
    }

    Model {
        id: tIRE1_003_Circle_016
        source: "meshes/tIRE1_003_Circle_016.mesh"
        materials: [
            material_material,
            material_014_material,
            material_025_material,
            material_017_material
        ]
    }

    Model {
        id: cube_002_Cube_012
        source: "meshes/cube_002_Cube_012.mesh"

        DefaultMaterial {
            id: material_018_material
            diffuseColor: "#ff999999"
        }
        materials: [
            material_018_material
        ]
    }*/

    Model {
        id: cube_062_Cube_064
        source: "meshes/cube_062_Cube_064.mesh"

        PrincipledMaterial {
            id: material_004_material
            baseColor: "#ff000022"
        }
        materials: [
            material_004_material
        ]
    }

/*    Model {
        id: circle_006_Circle_010
        source: "meshes/circle_006_Circle_010.mesh"

        DefaultMaterial {
            id: material_027_material
            diffuseColor: "#ff999999"
        }

        DefaultMaterial {
            id: material_042_material
            diffuseColor: "#ff999999"
        }

        DefaultMaterial {
            id: material_028_material
            diffuseColor: "#ff999999"
        }
        materials: [
            material_027_material,
            material_042_material,
            material_028_material
        ]
    }

    Model {
        id: cube_009_Cube_011
        source: "meshes/cube_009_Cube_011.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: cube_045_Cube_025
        source: "meshes/cube_045_Cube_025.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: cube_047_Cube_041
        source: "meshes/cube_047_Cube_041.mesh"
        materials: [
            material_014_material
        ]
    }

    Model {
        id: circle_009_Circle_014
        source: "meshes/circle_009_Circle_014.mesh"
        materials: [
            material_027_material,
            material_042_material,
            material_028_material
        ]
    }

    Model {
        id: plane_004
        source: "meshes/plane_004.mesh"
        materials: [
            material_017_material
        ]
    }*/
}
