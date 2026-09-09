cmake_minimum_required(VERSION 3.22)

project(MidiFlux VERSION 1.0.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_compile_definitions(JUCE_WEB_BROWSER=0 JUCE_USE_CURL=0)

# Add JUCE and CLAP extensions
add_subdirectory(libs/JUCE EXCLUDE_FROM_ALL)
add_subdirectory(libs/clap-juce-extensions EXCLUDE_FROM_ALL)

set(PLUGIN_FORMATS VST3 Standalone)
if(APPLE)
    list(APPEND PLUGIN_FORMATS AU)
endif()

juce_add_plugin(MidiFlux
    COMPANY_NAME "mtyas"
    BUNDLE_ID com.mtyas.midiflux
    IS_SYNTH TRUE
    NEEDS_MIDI_INPUT TRUE
    NEEDS_MIDI_OUTPUT TRUE
    IS_MIDI_EFFECT FALSE
    EDITOR_WANTS_KEYBOARD_FOCUS TRUE
    PLUGIN_MANUFACTURER_CODE MTYA
    PLUGIN_CODE MFlx
    FORMATS ${PLUGIN_FORMATS}
    PRODUCT_NAME "MidiFlux"
)

target_sources(MidiFlux PRIVATE
    # Common
    Source/Common/ScaleTheory.h
    Source/Common/ScaleProgression.h
    Source/Common/RandomUtils.h
    Source/Common/MidiBlock.h
    Source/Common/MidiBlockFactory.h
    Source/Common/MidiBlockFactory.cpp

    # Blocks
    Source/Blocks/ProbabilityBlock.h
    Source/Blocks/ProbabilityBlock.cpp
    Source/Blocks/MutatorBlock.h
    Source/Blocks/MutatorBlock.cpp
    Source/Blocks/ArpeggiatorBlock.h
    Source/Blocks/ArpeggiatorBlock.cpp
    Source/Blocks/ChordBlock.h
    Source/Blocks/ChordBlock.cpp
    Source/Blocks/HumanizerBlock.h
    Source/Blocks/HumanizerBlock.cpp
    Source/Blocks/ScaleQuantizeBlock.h
    Source/Blocks/ScaleQuantizeBlock.cpp
    Source/Blocks/TimeQuantizeBlock.h
    Source/Blocks/TimeQuantizeBlock.cpp
    Source/Blocks/TransposeBlock.h
    Source/Blocks/TransposeBlock.cpp
    Source/Blocks/FilterBlock.h
    Source/Blocks/FilterBlock.cpp
    Source/Blocks/MapperBlock.h
    Source/Blocks/MapperBlock.cpp
    Source/Blocks/TransformBlock.h
    Source/Blocks/TransformBlock.cpp
    Source/Blocks/LfoBlock.h
    Source/Blocks/LfoBlock.cpp
    Source/Blocks/RatchetBlock.h
    Source/Blocks/RatchetBlock.cpp
    Source/Blocks/DelayBlock.h
    Source/Blocks/DelayBlock.cpp
    Source/Blocks/EuclideanBlock.h
    Source/Blocks/EuclideanBlock.cpp
    Source/Blocks/HarmonizerBlock.h
    Source/Blocks/HarmonizerBlock.cpp

    # Engine
    Source/Engine/MidiChainProcessor.h
    Source/Engine/MidiChainProcessor.cpp
    Source/Engine/MidiLearnManager.h
    Source/Engine/MidiLearnManager.cpp
    Source/Engine/PresetManager.h
    Source/Engine/PresetManager.cpp
    Source/Engine/UndoHistoryManager.h
    Source/Engine/UndoHistoryManager.cpp

    # UI
    Source/UI/CustomLookAndFeel.h
    Source/UI/CustomLookAndFeel.cpp
    Source/UI/BlockCardComponent.h
    Source/UI/BlockCardComponent.cpp
    Source/UI/RackComponent.h
    Source/UI/RackComponent.cpp
    Source/UI/HeaderComponent.h
    Source/UI/HeaderComponent.cpp
    Source/UI/MidiMonitorComponent.h
    Source/UI/MidiMonitorComponent.cpp
    Source/UI/ScaleSequencerComponent.h
    Source/UI/ScaleSequencerComponent.cpp
    Source/UI/VirtualKeyboardComponent.h
    Source/UI/VirtualKeyboardComponent.cpp

    # Plugin Core
    Source/PluginProcessor.h
    Source/PluginProcessor.cpp
    Source/PluginEditor.h
    Source/PluginEditor.cpp
)

target_include_directories(MidiFlux PRIVATE
    Source
)

target_compile_definitions(MidiFlux PUBLIC
    JUCE_WEB_BROWSER=0
    JUCE_USE_CURL=0
    JUCE_VST3_CAN_REPLACE_VST2=0
)

target_link_libraries(MidiFlux PRIVATE
    juce::juce_audio_utils
    juce::juce_audio_processors
    juce::juce_gui_basics
    juce::juce_gui_extra
    juce::juce_data_structures
    juce::juce_graphics
    juce::juce_core
    clap_juce_extensions
)

clap_juce_extensions_plugin(TARGET MidiFlux
    CLAP_ID "com.mtyas.midiflux"
    CLAP_FEATURES instrument note-effect utility midi
)

# Automated Unit Tests
add_executable(MidiFluxTests Tests/UnitTests.cpp)
target_link_libraries(MidiFluxTests PRIVATE
    MidiFlux
    juce::juce_core
)
target_include_directories(MidiFluxTests PRIVATE Source)

# ==============================================================================
# CrossMod Synthesizer (VST3, Standalone, CLAP)
# ==============================================================================
juce_add_plugin(CrossMod
    COMPANY_NAME "mtyas"
    BUNDLE_ID com.mtyas.crossmod
    IS_SYNTH TRUE
    NEEDS_MIDI_INPUT TRUE
    NEEDS_MIDI_OUTPUT FALSE
    IS_MIDI_EFFECT FALSE
    EDITOR_WANTS_KEYBOARD_FOCUS TRUE
    PLUGIN_MANUFACTURER_CODE Mtya
    PLUGIN_CODE XM01
    FORMATS ${PLUGIN_FORMATS}
    PRODUCT_NAME "CrossMod"
)

target_sources(CrossMod PRIVATE
    Source/CrossMod/DSP/Envelope.h
    Source/CrossMod/DSP/LFO.h
    Source/CrossMod/DSP/VintageFilter.h
    Source/CrossMod/DSP/ModMatrix.h
    Source/CrossMod/DSP/CrossModVoice.h
    Source/CrossMod/DSP/CrossModEngine.h
    Source/CrossMod/DSP/CrossModEngine.cpp
    Source/CrossMod/DSP/Effects/ModulationEffect.h
    Source/CrossMod/DSP/Effects/DelayEffect.h
    Source/CrossMod/DSP/Effects/ReverbEffect.h
    Source/CrossMod/DSP/Effects/FxChain.h
    Source/CrossMod/Parameters/ParameterIDs.h
    Source/CrossMod/Parameters/ParameterIDs.cpp
    Source/CrossMod/Presets/FactoryPresets.h
    Source/CrossMod/Presets/PresetManager.h
    Source/CrossMod/Presets/PresetManager.cpp
    Source/CrossMod/MIDI/MidiLearnManager.h
    Source/CrossMod/MIDI/MidiLearnManager.cpp
    Source/CrossMod/UI/VintageLookAndFeel.h
    Source/CrossMod/UI/VintageLookAndFeel.cpp
    Source/CrossMod/UI/CrossModKnob.h
    Source/CrossMod/UI/CrossModKnob.cpp
    Source/CrossMod/UI/CrossModVisualizer.h
    Source/CrossMod/UI/CrossModVisualizer.cpp
    Source/CrossMod/UI/ModMatrixComponent.h
    Source/CrossMod/UI/ModMatrixComponent.cpp
    Source/CrossMod/UI/FxSectionComponent.h
    Source/CrossMod/UI/FxSectionComponent.cpp
    Source/CrossMod/UI/CrossModEditor.h
    Source/CrossMod/UI/CrossModEditor.cpp
    Source/CrossMod/CrossModProcessor.h
    Source/CrossMod/CrossModProcessor.cpp
)

target_include_directories(CrossMod PRIVATE
    Source/CrossMod
    Source
)

target_compile_definitions(CrossMod PUBLIC
    JUCE_WEB_BROWSER=0
    JUCE_USE_CURL=0
    JUCE_VST3_CAN_REPLACE_VST2=0
)

target_link_libraries(CrossMod PRIVATE
    juce::juce_audio_utils
    juce::juce_audio_processors
    juce::juce_gui_basics
    juce::juce_gui_extra
    juce::juce_data_structures
    juce::juce_graphics
    juce::juce_core
    juce::juce_audio_basics
    juce::juce_audio_formats
    juce::juce_dsp
    clap_juce_extensions
)

clap_juce_extensions_plugin(TARGET CrossMod
    CLAP_ID "com.mtyas.crossmod"
    CLAP_FEATURES instrument synthesizer
)

# CrossMod Unit Tests
add_executable(CrossModTests Tests/CrossModTests.cpp
    Source/CrossMod/DSP/CrossModEngine.cpp
    Source/CrossMod/Parameters/ParameterIDs.cpp
    Source/CrossMod/Presets/PresetManager.cpp
    Source/CrossMod/MIDI/MidiLearnManager.cpp
)
target_link_libraries(CrossModTests PRIVATE
    juce::juce_audio_basics
    juce::juce_audio_processors
    juce::juce_gui_basics
    juce::juce_core
)
target_include_directories(CrossModTests PRIVATE Source Source/CrossMod)

# ==============================================================================
# TransientSplit Audio Effect (VST3, Standalone, CLAP)
# ==============================================================================
# OmniSplit Audio Effect (VST3, Standalone, CLAP)
# ==============================================================================
juce_add_plugin(OmniSplit
    COMPANY_NAME "mtyas"
    BUNDLE_ID com.mtyas.omnisplit
    IS_SYNTH FALSE
    NEEDS_MIDI_INPUT FALSE
    NEEDS_MIDI_OUTPUT FALSE
    IS_MIDI_EFFECT FALSE
    EDITOR_WANTS_KEYBOARD_FOCUS FALSE
    PLUGIN_MANUFACTURER_CODE Mtya
    PLUGIN_CODE OmSp
    FORMATS ${PLUGIN_FORMATS}
    PRODUCT_NAME "OmniSplit"
)

target_sources(OmniSplit PRIVATE
    Source/TransientSplit/DSP/TransientExtractor.h
    Source/TransientSplit/DSP/FilterBank3.h
    Source/TransientSplit/DSP/PreProcessors/MidSideSplitter.h
    Source/TransientSplit/DSP/PreProcessors/DynamicSplitter.h
    Source/TransientSplit/DSP/PreProcessors/SpectralHarmonicSplitter.h
    Source/TransientSplit/DSP/PreProcessors/PhaseSpatialSplitter.h
    Source/TransientSplit/DSP/Effects/BaseEffect.h
    Source/TransientSplit/DSP/Effects/CompressorVCAEffect.h
    Source/TransientSplit/DSP/Effects/CompressorOptoEffect.h
    Source/TransientSplit/DSP/Effects/CompressorFETEffect.h
    Source/TransientSplit/DSP/Effects/GateEffect.h
    Source/TransientSplit/DSP/Effects/EqualizerParametricEffect.h
    Source/TransientSplit/DSP/Effects/EqualizerGraphicEffect.h
    Source/TransientSplit/DSP/Effects/EqualizerTiltEffect.h
    Source/TransientSplit/DSP/Effects/FilterDualHPLPEffect.h
    Source/TransientSplit/DSP/Effects/FilterBandpassEffect.h
    Source/TransientSplit/DSP/Effects/DistortionHardClipEffect.h
    Source/TransientSplit/DSP/Effects/DistortionTubeEffect.h
    Source/TransientSplit/DSP/Effects/DistortionWavefolderEffect.h
    Source/TransientSplit/DSP/Effects/FuzzGermaniumEffect.h
    Source/TransientSplit/DSP/Effects/FuzzOctaveEffect.h
    Source/TransientSplit/DSP/Effects/OverdriveEffect.h
    Source/TransientSplit/DSP/Effects/TapeEffect.h
    Source/TransientSplit/DSP/Effects/BitcrushEffect.h
    Source/TransientSplit/DSP/Effects/GlitchStutterEffect.h
    Source/TransientSplit/DSP/Effects/GlitchTapeStopEffect.h
    Source/TransientSplit/DSP/Effects/GlitchReverseEffect.h
    Source/TransientSplit/DSP/Effects/GlitchGranularEffect.h
    Source/TransientSplit/DSP/Effects/PitchShifterEffect.h
    Source/TransientSplit/DSP/Effects/FrequencyShifterEffect.h
    Source/TransientSplit/DSP/Effects/ModulationChorusEffect.h
    Source/TransientSplit/DSP/Effects/ModulationFlangerEffect.h
    Source/TransientSplit/DSP/Effects/ModulationPhaserEffect.h
    Source/TransientSplit/DSP/Effects/ModulationTremoloEffect.h
    Source/TransientSplit/DSP/Effects/DelayStereoEffect.h
    Source/TransientSplit/DSP/Effects/DelayPingPongEffect.h
    Source/TransientSplit/DSP/Effects/DelayTapeEchoEffect.h
    Source/TransientSplit/DSP/Effects/ReverbRoomEffect.h
    Source/TransientSplit/DSP/Effects/ReverbHallEffect.h
    Source/TransientSplit/DSP/Effects/ReverbPlateEffect.h
    Source/TransientSplit/DSP/Effects/ReverbSpringEffect.h
    Source/TransientSplit/DSP/Effects/ReverbShimmerEffect.h
    Source/TransientSplit/DSP/EffectChain.h
    Source/TransientSplit/DSP/TransientSplitEngine.h
    Source/TransientSplit/DSP/Modulation/ModLFO.h
    Source/TransientSplit/DSP/Modulation/ModEnvelopeFollower.h
    Source/TransientSplit/DSP/Modulation/ModTuringMachine.h
    Source/TransientSplit/DSP/Modulation/ModMatrix.h
    Source/TransientSplit/DSP/Modulation/ModEngine.h
    Source/TransientSplit/Parameters/ParameterIDs.h
    Source/TransientSplit/Parameters/ParameterIDs.cpp
    Source/TransientSplit/Presets/FactoryPresets.h
    Source/TransientSplit/Presets/PresetManager.h
    Source/TransientSplit/Presets/PresetManager.cpp
    Source/TransientSplit/UI/TransientLookAndFeel.h
    Source/TransientSplit/UI/TransientLookAndFeel.cpp
    Source/TransientSplit/UI/RealtimeVisualizer.h
    Source/TransientSplit/UI/RealtimeVisualizer.cpp
    Source/TransientSplit/UI/FilterBankPanelComponent.h
    Source/TransientSplit/UI/FilterBankPanelComponent.cpp
    Source/TransientSplit/UI/TransientSplitPanelComponent.h
    Source/TransientSplit/UI/TransientSplitPanelComponent.cpp
    Source/TransientSplit/UI/AdvancedPreProcessorsComponent.h
    Source/TransientSplit/UI/AudioRoutingDiagramComponent.h
    Source/TransientSplit/UI/AudioRoutingDiagramComponent.cpp
    Source/TransientSplit/UI/PreProcessorsCombinedComponent.h
    Source/TransientSplit/UI/EffectSlotComponent.h
    Source/TransientSplit/UI/EffectSlotComponent.cpp
    Source/TransientSplit/UI/ChainRackComponent.h
    Source/TransientSplit/UI/ChainRackComponent.cpp
    Source/TransientSplit/UI/SplitControlsComponent.h
    Source/TransientSplit/UI/SplitControlsComponent.cpp
    Source/TransientSplit/UI/ModulatorsPanelComponent.h
    Source/TransientSplit/UI/ModulatorsPanelComponent.cpp
    Source/TransientSplit/UI/ModMatrixComponent.h
    Source/TransientSplit/UI/ModMatrixComponent.cpp
    Source/TransientSplit/UI/XYPadComponent.h
    Source/TransientSplit/UI/XYPadComponent.cpp
    Source/TransientSplit/UI/TransientSplitEditor.h
    Source/TransientSplit/UI/TransientSplitEditor.cpp
    Source/TransientSplit/TransientSplitProcessor.h
    Source/TransientSplit/TransientSplitProcessor.cpp
)

target_include_directories(OmniSplit PRIVATE
    Source/TransientSplit
    Source
)

target_compile_definitions(OmniSplit PUBLIC
    JUCE_WEB_BROWSER=0
    JUCE_USE_CURL=0
    JUCE_VST3_CAN_REPLACE_VST2=0
)

target_link_libraries(OmniSplit PRIVATE
    juce::juce_audio_utils
    juce::juce_audio_processors
    juce::juce_gui_basics
    juce::juce_gui_extra
    juce::juce_data_structures
    juce::juce_graphics
    juce::juce_core
    juce::juce_audio_basics
    juce::juce_audio_formats
    juce::juce_dsp
    clap_juce_extensions
)

clap_juce_extensions_plugin(TARGET OmniSplit
    CLAP_ID "com.mtyas.omnisplit"
    CLAP_FEATURES audio-effect distortion filter
)

# OmniSplit Unit Tests
add_executable(OmniSplitTests Tests/TransientSplitTests.cpp
    Source/TransientSplit/Parameters/ParameterIDs.cpp
    Source/TransientSplit/Presets/PresetManager.cpp
)
target_link_libraries(OmniSplitTests PRIVATE
    juce::juce_audio_basics
    juce::juce_audio_processors
    juce::juce_gui_basics
    juce::juce_core
    juce::juce_dsp
)
target_include_directories(OmniSplitTests PRIVATE Source Source/TransientSplit)



