# -*- coding: utf-8 -*-

from psd_tools import PSDImage
from psd_tools.constants import Tag
from psd_tools.constants import EffectOSType
from psd_tools.api.effects import Effects
from psd_tools.terminology import Klass, Key, Enum, Type
from psd_tools.psd.descriptor import List
from extract.utils import Utils


class EffectsExtract:
    _layer = None
    _effectsList = None
    _effectLen = 0
    _retList = []

    def __init__(self, layer_obj):
        self._retList = []
        self._layer = layer_obj
        self._effectsList = layer_obj.effects
        self._effectsLen = len(self._effectsList)
        self.check()
        self.doExtract()

    def check(self):
        if not isinstance(self._effectsList, Effects):
            return []
        if not self._effectsList.enabled:
            return []

    def doExtract(self):
        for efItem in self._effectsList:
            if 'Stroke'.lower() == efItem.__class__.__name__.lower():       # 描边
                tmp = self.StrokeEffect(efItem)
                self._retList.append(tmp)
            elif 'InnerShadow'.lower() == efItem.__class__.__name__.lower():    # 内阴影
                tmp = self.InnerShadowEffect(efItem)
                self._retList.append(tmp)
            elif 'DropShadow'.lower() == efItem.__class__.__name__.lower():     # 投影
                tmp = self.DropShadowEffect(efItem)
                self._retList.append(tmp)
            elif 'OuterGlow'.lower() == efItem.__class__.__name__.lower():      # 外发光
                tmp = self.OuterGlowEffect(efItem)
                self._retList.append(tmp)
            elif 'InnerGlow'.lower() == efItem.__class__.__name__.lower():      # 内发光
                tmp = self.InnerGlowEffect(efItem)
                self._retList.append(tmp)
            elif 'ColorOverlay'.lower() == efItem.__class__.__name__.lower():       # 颜色叠加
                tmp = self.ColorOverlayEffect(efItem)
                self._retList.append(tmp)
            elif 'GradientOverlay'.lower() == efItem.__class__.__name__.lower():        # 渐变叠加
                tmp = self.GradientOverlayEffect(efItem)
                self._retList.append(tmp)
            elif 'PatternOverlay'.lower() == efItem.__class__.__name__.lower():     # 图案叠加
                tmp = self.PatternOverlayEffect(efItem)
                self._retList.append(tmp)
            elif 'Satin'.lower() == efItem.__class__.__name__.lower():      # 光泽
                tmp = self.SatinEffect(efItem)
                self._retList.append(tmp)
            elif 'BevelEmboss'.lower() == efItem.__class__.__name__.lower():        # 光泽
                tmp = self.BevelEmbossEffect(efItem)
                self._retList.append(tmp)

    def parse(self):
        return self._retList

    def StrokeEffect(self, obj):
        ret = {}
        ret['effect_type'] = 'Stroke'
        ret['blend_mode'] = Utils.getTerminologyKey(obj.blend_mode, 'Enum')
        ret['color'] = Utils.formatColor(obj.color)
        ret['enabled'] = obj.enabled
        ret['present'] = obj.present
        ret['shown'] = obj.shown
        #
        ret['fill_type'] = Utils.getTerminologyKey(obj.fill_type, 'Enum')
        ret['gradient'] = Utils.formatGradient(obj.gradient)
        ret['opacity'] = obj.opacity
        ret['overprint'] = obj.overprint
        ret['pattern'] = Utils.formatPattern(obj.pattern)
        ret['position'] = Utils.getTerminologyKey(obj.position, 'Enum')
        ret['size'] = obj.size
        return ret

    def InnerShadowEffect(self, obj):
        ret = {}
        ret['effect_type'] = 'InnerShadow'
        ret['blend_mode'] = Utils.getTerminologyKey(obj.blend_mode, 'Enum')
        ret['color'] = Utils.formatColor(obj.color)
        ret['enabled'] = obj.enabled
        ret['present'] = obj.present
        ret['shown'] = obj.shown
        #
        ret['angle'] = obj.angle
        ret['anti_aliased'] = obj.anti_aliased
        ret['choke'] = obj.choke
        ret['contour'] = Utils.formatContour(obj.contour)
        ret['distance'] = obj.distance
        ret['noise'] = obj.noise
        ret['opacity'] = obj.opacity
        ret['size'] = obj.size
        ret['use_global_light'] = obj.use_global_light
        return ret

    def DropShadowEffect(self, obj):
        ret = {}
        ret['effect_type'] = 'DropShadow'
        ret['blend_mode'] = Utils.getTerminologyKey(obj.blend_mode, 'Enum')
        ret['color'] = Utils.formatColor(obj.color)
        ret['enabled'] = obj.enabled
        ret['present'] = obj.present
        ret['shown'] = obj.shown
        #
        ret['angle'] = obj.angle
        ret['anti_aliased'] = obj.anti_aliased
        ret['choke'] = obj.choke
        ret['contour'] = Utils.formatContour(obj.contour)
        ret['distance'] = obj.distance
        ret['noise'] = obj.noise
        ret['opacity'] = obj.opacity
        ret['size'] = obj.size
        ret['use_global_light'] = obj.use_global_light
        ret['layer_knocks_out'] = obj.layer_knocks_out
        return ret

    def OuterGlowEffect(self, obj):
        ret = {}
        ret['effect_type'] = 'OuterGLow'
        ret['blend_mode'] = Utils.getTerminologyKey(obj.blend_mode, 'Enum')
        ret['color'] = Utils.formatColor(obj.color)
        ret['enabled'] = obj.enabled
        ret['present'] = obj.present
        ret['shown'] = obj.shown
        #
        ret['anti_aliased'] = obj.anti_aliased
        ret['choke'] = obj.choke
        ret['contour'] = Utils.formatContour(obj.contour)
        ret['noise'] = obj.noise
        ret['opacity'] = obj.opacity
        ret['size'] = obj.size
        ret['glow_type'] = Utils.getTerminologyKey(obj.glow_type)
        ret['gradient'] = obj.gradient
        ret['quality_jitter'] = obj.quality_jitter
        ret['quality_range'] = obj.quality_range
        return ret

    def InnerGlowEffect(self, obj):
        ret = {}
        ret['effect_type'] = 'InnerGlow'
        ret['blend_mode'] = Utils.getTerminologyKey(obj.blend_mode, 'Enum')
        ret['color'] = Utils.formatColor(obj.color)
        ret['enabled'] = obj.enabled
        ret['present'] = obj.present
        ret['shown'] = obj.shown
        #
        ret['anti_aliased'] = obj.anti_aliased
        ret['choke'] = obj.choke
        ret['contour'] = Utils.formatContour(obj.contour)
        ret['noise'] = obj.noise
        ret['opacity'] = obj.opacity
        ret['size'] = obj.size
        ret['glow_type'] = Utils.getTerminologyKey(obj.glow_type)
        ret['gradient'] = Utils.formatGradient(obj.gradient)
        ret['quality_jitter'] = obj.quality_jitter
        ret['quality_range'] = obj.quality_range
        ret['glow_source'] = Utils.getTerminologyKey(obj.glow_source)
        return ret

    def ColorOverlayEffect(self, obj):
        ret = {}
        ret['effect_type'] = 'ColorOverlay'
        ret['blend_mode'] = Utils.getTerminologyKey(obj.blend_mode, 'Enum')
        ret['color'] = Utils.formatColor(obj.color)
        ret['enabled'] = obj.enabled
        ret['present'] = obj.present
        ret['shown'] = obj.shown
        return ret

    def GradientOverlayEffect(self, obj):
        ret = {}
        ret['effect_type'] = 'GradientOverlay'
        ret['blend_mode'] = Utils.getTerminologyKey(obj.blend_mode, 'Enum')
        ret['aligned'] = obj.aligned
        ret['enabled'] = obj.enabled
        ret['present'] = obj.present
        ret['shown'] = obj.shown
        ret['angle'] = obj.angle
        ret['dithered'] = obj.dithered
        ret['gradient'] = Utils.formatGradient(obj.gradient)
        ret['offset'] = Utils.formatOffset(obj.offset)
        ret['opacity'] = obj.opacity
        ret['reversed'] = obj.reversed
        ret['scale'] = obj.scale
        ret['type'] = Utils.getTerminologyKey(obj.type)
        return ret

    def PatternOverlayEffect(self, obj):
        ret = {}
        ret['effect_type'] = 'PatternOverlay'
        ret['blend_mode'] = Utils.getTerminologyKey(obj.blend_mode, 'Enum')
        ret['aligned'] = obj.aligned
        ret['enabled'] = obj.enabled
        ret['present'] = obj.present
        ret['shown'] = obj.shown
        ret['opacity'] = obj.opacity
        ret['pattern'] = Utils.formatPattern(obj.pattern)
        ret['phase'] = Utils.formatPhase(obj.phase)
        ret['scale'] = obj.scale
        return ret

    def SatinEffect(self, obj):
        ret = {}
        ret['effect_type'] = 'Satin'
        ret['blend_mode'] = Utils.getTerminologyKey(obj.blend_mode, 'Enum')
        ret['color'] = Utils.formatColor(obj.color)
        ret['contour'] = Utils.formatContour(obj.contour)
        ret['angle'] = obj.angle
        ret['enabled'] = obj.enabled
        ret['present'] = obj.present
        ret['shown'] = obj.shown
        ret['opacity'] = obj.opacity
        ret['anti_aliased'] = obj.anti_aliased
        ret['distance'] = obj.distance
        ret['inverted'] = obj.inverted
        ret['size'] = obj.size
        return ret

    def BevelEmbossEffect(self, obj):
        ret = {}
        ret['effect_type'] = 'BevelEmboss'
        ret['altitude'] = obj.altitude
        ret['angle'] = obj.angle
        ret['anti_aliased'] = obj.anti_aliased
        ret['bevel_style'] = Utils.getTerminologyKey(obj.bevel_style)
        ret['bevel_type'] = Utils.getTerminologyKey(obj.bevel_type)
        ret['contour'] = Utils.formatContour(obj.contour)
        ret['depth'] = obj.depth
        ret['direction'] = Utils.getTerminologyKey(obj.direction)
        ret['enabled'] = obj.enabled
        ret['highlight_color'] = Utils.formatColor(obj.highlight_color)
        ret['highlight_mode'] = Utils.getTerminologyKey(obj.highlight_mode)
        ret['highlight_opacity'] = obj.highlight_opacity
        ret['present'] = obj.present
        ret['shadow_color'] = Utils.formatColor(obj.shadow_color)
        ret['shadow_mode'] = Utils.getTerminologyKey(obj.shadow_mode)
        ret['shadow_opacity'] = obj.shadow_opacity
        ret['shown'] = obj.shown
        ret['size'] = obj.size
        ret['soften'] = obj.soften
        ret['use_global_light'] = obj.use_global_light
        ret['use_shape'] = obj.use_shape
        ret['use_texture'] = obj.use_texture
        return ret







