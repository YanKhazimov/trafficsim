import QtQuick 2.15
import QtQuick3D 1.15

//import "models3d/xc70"

Node {
    id: car_2012_Volvo_XC70__Traffic__N300718_obj

    property alias metalness: body_material.metalness
    property alias roughness: body_material.roughness
    property alias color: body_material.baseColor

    scale: Qt.vector3d(75, 75, 75)
    y: -100

/*    Model {
        id: vol_xc70_12_body_badge_
        source: "meshes/vol_xc70_12_body_badge_.mesh"

        DefaultMaterial {
            id: badge_material
        }
        materials: [
            badge_material
        ]
    }

    Model {
        id: vol_xc70_12_body_black_glass_
        source: "meshes/vol_xc70_12_body_black_glass_.mesh"

        DefaultMaterial {
            id: black_glass_material
            diffuseColor: "#ff000000"
        }
        materials: [
            black_glass_material
        ]
    }*/

    Model {
        id: vol_xc70_12_body_body_
        source: "meshes/vol_xc70_12_body_body_.mesh"

        PrincipledMaterial {
            id: body_material
            baseColor: "#ff000022"
        }
        materials: [
            body_material
        ]
    }

/*    Model {
        id: vol_xc70_12_body_emblem_
        source: "meshes/vol_xc70_12_body_emblem_.mesh"

        DefaultMaterial {
            id: emblem_material
        }
        materials: [
            emblem_material
        ]
    }

    Model {
        id: vol_xc70_12_body_frame_
        source: "meshes/vol_xc70_12_body_frame_.mesh"

        DefaultMaterial {
            id: frame_material
        }
        materials: [
            frame_material
        ]
    }

    Model {
        id: vol_xc70_12_body_matte_colors_
        source: "meshes/vol_xc70_12_body_matte_colors_.mesh"

        DefaultMaterial {
            id: matte_colors_material
        }
        materials: [
            matte_colors_material
        ]
    }

    Model {
        id: vol_xc70_12_body_plastic2_
        source: "meshes/vol_xc70_12_body_plastic2_.mesh"

        DefaultMaterial {
            id: plastic2_material
        }
        materials: [
            plastic2_material
        ]
    }

    Model {
        id: vol_xc70_12_body_rubber_trim_
        source: "meshes/vol_xc70_12_body_rubber_trim_.mesh"

        DefaultMaterial {
            id: rubber_trim_material
            diffuseColor: "#ff000000"
        }
        materials: [
            rubber_trim_material
        ]
    }

    Model {
        id: vol_xc70_12_bumperFrameF_numberplate_
        source: "meshes/vol_xc70_12_bumperFrameF_numberplate_.mesh"

        DefaultMaterial {
            id: numberplate_material
        }
        materials: [
            numberplate_material
        ]
    }

    Model {
        id: vol_xc70_12_bumperFrameR_numberplate_
        source: "meshes/vol_xc70_12_bumperFrameR_numberplate_.mesh"
        materials: [
            numberplate_material
        ]
    }

    Model {
        id: vol_xc70_12_exhaustLa_chrome_
        source: "meshes/vol_xc70_12_exhaustLa_chrome_.mesh"

        DefaultMaterial {
            id: chrome_material
            diffuseColor: "#ff000000"
        }
        materials: [
            chrome_material
        ]
    }

    Model {
        id: vol_xc70_12_exhaustLa_frame_
        source: "meshes/vol_xc70_12_exhaustLa_frame_.mesh"
        materials: [
            frame_material
        ]
    }

    Model {
        id: vol_xc70_12_glassF_glass_
        source: "meshes/vol_xc70_12_glassF_glass_.mesh"

        DefaultMaterial {
            id: glass_material
            diffuseColor: "#ff000000"
            opacity: 0.4
        }
        materials: [
            glass_material
        ]
    }

    Model {
        id: vol_xc70_12_glassLF_glass_
        source: "meshes/vol_xc70_12_glassLF_glass_.mesh"
        materials: [
            glass_material
        ]
    }

    Model {
        id: vol_xc70_12_glassLM_glass_
        source: "meshes/vol_xc70_12_glassLM_glass_.mesh"
        materials: [
            glass_material
        ]
    }

    Model {
        id: vol_xc70_12_glassLR_glass_
        source: "meshes/vol_xc70_12_glassLR_glass_.mesh"
        materials: [
            glass_material
        ]
    }

    Model {
        id: vol_xc70_12_glassR_glass_
        source: "meshes/vol_xc70_12_glassR_glass_.mesh"
        materials: [
            glass_material
        ]
    }

    Model {
        id: vol_xc70_12_glassRF_glass_
        source: "meshes/vol_xc70_12_glassRF_glass_.mesh"
        materials: [
            glass_material
        ]
    }

    Model {
        id: vol_xc70_12_glassRM_glass_
        source: "meshes/vol_xc70_12_glassRM_glass_.mesh"
        materials: [
            glass_material
        ]
    }

    Model {
        id: vol_xc70_12_glassRR_glass_
        source: "meshes/vol_xc70_12_glassRR_glass_.mesh"
        materials: [
            glass_material
        ]
    }

    Model {
        id: vol_xc70_12_glassRTL_detail_glass_red_
        source: "meshes/vol_xc70_12_glassRTL_detail_glass_red_.mesh"

        DefaultMaterial {
            id: detail_glass_red_material
            diffuseColor: "#ffff8080"
            opacity: 0.92
        }
        materials: [
            detail_glass_red_material
        ]
    }

    Model {
        id: vol_xc70_12_glassRTL_glass_
        source: "meshes/vol_xc70_12_glassRTL_glass_.mesh"
        materials: [
            glass_material
        ]
    }

    Model {
        id: vol_xc70_12_glassRTL_lights_gls_noemit_
        source: "meshes/vol_xc70_12_glassRTL_lights_gls_noemit_.mesh"

        DefaultMaterial {
            id: lights_gls_noemit_material
            opacity: 0.92
        }
        materials: [
            lights_gls_noemit_material
        ]
    }

    Model {
        id: vol_xc70_12_interior_chrome_
        source: "meshes/vol_xc70_12_interior_chrome_.mesh"
        materials: [
            chrome_material
        ]
    }

    Model {
        id: vol_xc70_12_interior_interior_
        source: "meshes/vol_xc70_12_interior_interior_.mesh"

        DefaultMaterial {
            id: interior_material
        }
        materials: [
            interior_material
        ]
    }

    Model {
        id: vol_xc70_12_mirrorL_body_
        source: "meshes/vol_xc70_12_mirrorL_body_.mesh"
        materials: [
            body_material
        ]
    }

    Model {
        id: vol_xc70_12_mirrorL_chrome_
        source: "meshes/vol_xc70_12_mirrorL_chrome_.mesh"
        materials: [
            chrome_material
        ]
    }

    Model {
        id: vol_xc70_12_mirrorL_frame_
        source: "meshes/vol_xc70_12_mirrorL_frame_.mesh"
        materials: [
            frame_material
        ]
    }

    Model {
        id: vol_xc70_12_mirrorL_matte_colors_
        source: "meshes/vol_xc70_12_mirrorL_matte_colors_.mesh"
        materials: [
            matte_colors_material
        ]
    }

    Model {
        id: vol_xc70_12_mirrorR_body_
        source: "meshes/vol_xc70_12_mirrorR_body_.mesh"
        materials: [
            body_material
        ]
    }

    Model {
        id: vol_xc70_12_mirrorR_chrome_
        source: "meshes/vol_xc70_12_mirrorR_chrome_.mesh"
        materials: [
            chrome_material
        ]
    }

    Model {
        id: vol_xc70_12_mirrorR_frame_
        source: "meshes/vol_xc70_12_mirrorR_frame_.mesh"
        materials: [
            frame_material
        ]
    }

    Model {
        id: vol_xc70_12_mirrorR_matte_colors_
        source: "meshes/vol_xc70_12_mirrorR_matte_colors_.mesh"
        materials: [
            matte_colors_material
        ]
    }

    Model {
        id: vol_xc70_12_seatL_interior_
        source: "meshes/vol_xc70_12_seatL_interior_.mesh"
        materials: [
            interior_material
        ]
    }

    Model {
        id: vol_xc70_12_seatR_interior_
        source: "meshes/vol_xc70_12_seatR_interior_.mesh"
        materials: [
            interior_material
        ]
    }

    Model {
        id: vol_xc70_12_steering_wheel_interior_
        source: "meshes/vol_xc70_12_steering_wheel_interior_.mesh"
        materials: [
            interior_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_fogred_
        source: "meshes/vol_xc70_12_taillightR_fogred_.mesh"

        DefaultMaterial {
            id: fogred_material
        }
        materials: [
            fogred_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_fogwhite_
        source: "meshes/vol_xc70_12_taillightR_fogwhite_.mesh"

        DefaultMaterial {
            id: fogwhite_material
        }
        materials: [
            fogwhite_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_frame_
        source: "meshes/vol_xc70_12_taillightR_frame_.mesh"
        materials: [
            frame_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_fullbeam_
        source: "meshes/vol_xc70_12_taillightR_fullbeam_.mesh"

        DefaultMaterial {
            id: fullbeam_material
        }
        materials: [
            fullbeam_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_head_light_
        source: "meshes/vol_xc70_12_taillightR_head_light_.mesh"

        DefaultMaterial {
            id: head_light_material
        }
        materials: [
            head_light_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_indicator_left_
        source: "meshes/vol_xc70_12_taillightR_indicator_left_.mesh"

        DefaultMaterial {
            id: indicator_left_material
            opacity: 0.92
        }
        materials: [
            indicator_left_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_indicator_right_
        source: "meshes/vol_xc70_12_taillightR_indicator_right_.mesh"

        DefaultMaterial {
            id: indicator_right_material
            opacity: 0.92
        }
        materials: [
            indicator_right_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_matte_colors_
        source: "meshes/vol_xc70_12_taillightR_matte_colors_.mesh"
        materials: [
            matte_colors_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_numplate_
        source: "meshes/vol_xc70_12_taillightR_numplate_.mesh"

        DefaultMaterial {
            id: numplate_material
        }
        materials: [
            numplate_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_oldhead_
        source: "meshes/vol_xc70_12_taillightR_oldhead_.mesh"

        DefaultMaterial {
            id: oldhead_material
        }
        materials: [
            oldhead_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_reverse_light_
        source: "meshes/vol_xc70_12_taillightR_reverse_light_.mesh"

        DefaultMaterial {
            id: reverse_light_material
            opacity: 0.92
        }
        materials: [
            reverse_light_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_slorange_
        source: "meshes/vol_xc70_12_taillightR_slorange_.mesh"

        DefaultMaterial {
            id: slorange_material
        }
        materials: [
            slorange_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_tail_light_
        source: "meshes/vol_xc70_12_taillightR_tail_light_.mesh"

        DefaultMaterial {
            id: tail_light_material
        }
        materials: [
            tail_light_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_taillightst_
        source: "meshes/vol_xc70_12_taillightR_taillightst_.mesh"

        DefaultMaterial {
            id: taillightst_material
            opacity: 0.92
        }
        materials: [
            taillightst_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_reflector_
        source: "meshes/vol_xc70_12_taillightR_reflector_.mesh"

        DefaultMaterial {
            id: reflector_material
        }
        materials: [
            reflector_material
        ]
    }

    Model {
        id: vol_xc70_12_taillightR_xenonhead_
        source: "meshes/vol_xc70_12_taillightR_xenonhead_.mesh"

        DefaultMaterial {
            id: xenonhead_material
        }
        materials: [
            xenonhead_material
        ]
    }

    Model {
        id: vol_xc70_12_undercarriagea_undercarriage_
        source: "meshes/vol_xc70_12_undercarriagea_undercarriage_.mesh"

        DefaultMaterial {
            id: undercarriage_material
        }
        materials: [
            undercarriage_material
        ]
    }

    Model {
        id: vol_xc70_12_wheel_wheel_rim_
        source: "meshes/vol_xc70_12_wheel_wheel_rim_.mesh"

        DefaultMaterial {
            id: rim_material
        }
        materials: [
            rim_material
        ]
    }

    Model {
        id: vol_xc70_12_wheel_wheel_tire_
        source: "meshes/vol_xc70_12_wheel_wheel_tire_.mesh"

        DefaultMaterial {
            id: tire_material
        }
        materials: [
            tire_material
        ]
    }

    Model {
        id: vol_xc70_12_wheel_wheel_inner_rim_
        source: "meshes/vol_xc70_12_wheel_wheel_inner_rim_.mesh"

        DefaultMaterial {
            id: inner_rim_material
        }
        materials: [
            inner_rim_material
        ]
    }

    Model {
        id: vol_xc70_12_wheel_wheel_inner_rim_01
        source: "meshes/vol_xc70_12_wheel_wheel_inner_rim_01.mesh"
        materials: [
            inner_rim_material
        ]
    }

    Model {
        id: vol_xc70_12_wheel_wheel_rim_01
        source: "meshes/vol_xc70_12_wheel_wheel_rim_01.mesh"
        materials: [
            rim_material
        ]
    }

    Model {
        id: vol_xc70_12_wheel_wheel_tire_01
        source: "meshes/vol_xc70_12_wheel_wheel_tire_01.mesh"
        materials: [
            tire_material
        ]
    }

    Model {
        id: vol_xc70_12_wheel_wheel_tire_02
        source: "meshes/vol_xc70_12_wheel_wheel_tire_02.mesh"
        materials: [
            tire_material
        ]
    }

    Model {
        id: vol_xc70_12_wheel_wheel_inner_rim_02
        source: "meshes/vol_xc70_12_wheel_wheel_inner_rim_02.mesh"
        materials: [
            inner_rim_material
        ]
    }

    Model {
        id: vol_xc70_12_wheel_wheel_rim_03
        source: "meshes/vol_xc70_12_wheel_wheel_rim_03.mesh"
        materials: [
            rim_material
        ]
    }

    Model {
        id: vol_xc70_12_wheel_wheel_inner_rim_03
        source: "meshes/vol_xc70_12_wheel_wheel_inner_rim_03.mesh"
        materials: [
            inner_rim_material
        ]
    }

    Model {
        id: vol_xc70_12_wheel_wheel_rim_02
        source: "meshes/vol_xc70_12_wheel_wheel_rim_02.mesh"
        materials: [
            rim_material
        ]
    }

    Model {
        id: vol_xc70_12_wheel_wheel_tire_03
        source: "meshes/vol_xc70_12_wheel_wheel_tire_03.mesh"
        materials: [
            tire_material
        ]
    }*/
}
