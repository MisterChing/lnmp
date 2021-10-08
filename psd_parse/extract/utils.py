# -*- coding: utf-8 -*-

from psd_tools.terminology import Klass, Enum, Event, Form, Key, P, Type, Unit


class Utils:

    @staticmethod
    def formatColor(obj):
        return {
            'red': round(obj.get(Key.Red).value),
            'green': round(obj.get(Key.Green).value),
            'blue': round(obj.get(Key.Blue).value),
        }

    @staticmethod
    def formatGradient(obj):
        if obj is None:
            return {}
        ret = {}
        ret['name'] = obj.get(Key.Name).value
        ret['colors'] = Utils.formatColorsList(obj.get(Key.Colors))
        ret[Key.GradientFill.name.lower()] = obj.get(Key.GradientFill)
        ret[Key.Interlace.name.lower()] = obj.get(Key.Interlace).value
        return ret

    @staticmethod
    def formatColorsList(obj):
        colorList = []
        for k in obj:
            tmp = {}
            tmp['color'] = Utils.formatColor(k.get(Key.Color))
            tmp[Utils.getTerminologyKey(Key.Type).lower()] = k.get(Key.Type).get_name()
            tmp[Utils.getTerminologyKey(Key.Location).lower()] = k.get(Key.Location).value
            tmp[Utils.getTerminologyKey(Key.Midpoint).lower()] = k.get(Key.Midpoint).value
            colorList.append(tmp)
        return colorList

    @staticmethod
    def getTerminologyKey(obj, name=None):
        if name is not None:
            for target in [Klass, Enum, Event, Form, Key, P, Type, Unit]:
                if name.lower() == target.__name__.lower():
                    if obj in target.value2member_map_:
                        return target.value2member_map_.get(obj).name
        else:
            for item in [Klass, Enum, Event, Form, Key, P, Type, Unit]:
                if obj in item.value2member_map_:
                    return item.value2member_map_.get(obj).name
        return None

    @staticmethod
    def formatContour(obj):
        ret = {}
        ret['name'] = obj.get(Key.Name).value.strip('\x00')
        tmpList = []
        for item in obj.get(Key.Curve):
            tmp = {
                Key.Horizontal.name.lower(): item.get(Key.Horizontal).value,
                Key.Vertical.name.lower(): item.get(Key.Vertical).value,
            }
            tmpList.append(tmp)
        ret[Key.Curve.name.lower()] = tmpList
        return ret


    @staticmethod
    def formatOffset(obj):
        ret = {}
        ret[Key.Horizontal.name.lower()] = obj.get(Key.Horizontal).value
        ret[Key.Vertical.name.lower()] = obj.get(Key.Vertical).value
        return ret

    @staticmethod
    def formatPhase(obj):
        ret = {}
        ret[Key.Horizontal.name.lower()] = obj.get(Key.Horizontal).value
        ret[Key.Vertical.name.lower()] = obj.get(Key.Vertical).value
        return ret

    @staticmethod
    def formatPattern(obj):
        ret = {}
        ret[Key.Name.name.lower()] = obj.get(Key.Name).value
        ret[Key.ID.name.lower()] = obj.get(Key.ID).value
        return ret

    @staticmethod
    def formatTextAlignment(obj):
        key = str(obj)
        alignment_map = {
            '0': 'left',
            '2': 'center',
            '1': 'right',
            '6': 'justify'
        }
        return alignment_map.get(key, 'left')

    @staticmethod
    def formatTextColor(obj):
        """
        :param obj:
        :return: argb [1.0,255,255,255]
        """
        colorList = list()
        for v in obj:
            colorList.append(v.value)
        return colorList
