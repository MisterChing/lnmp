# -*- coding: utf-8 -*-

from extract.utils import Utils
import math


class FrontAttr:
    _layer = None
    _engine_dict = None
    _resource_dict = None
    _tagged_blocks = None
    _paragraphProperties = None
    _transform = None
    _retData = None

    def __init__(self, layer_obj):
        self._retData = dict()
        self._layer = layer_obj
        self._engine_dict = layer_obj.engine_dict
        self._resource_dict = layer_obj.resource_dict
        self._tagged_blocks = layer_obj.tagged_blocks
        self._transform = layer_obj.transform
        self._paragraphProperties = self._engine_dict['ParagraphRun']['RunArray'][0]['ParagraphSheet']['Properties']

    def parse(self):
        # Extract font for each substring in the text.
        text = self._engine_dict['Editor']['Text'].value
        fontset = self._resource_dict['FontSet']
        runlength = self._engine_dict['StyleRun']['RunLengthArray']
        rundata = self._engine_dict['StyleRun']['RunArray']
        index = 0
        self._retData['text'] = text.encode('utf-8').decode('utf-8')
        text_lines = len(self._retData['text'].rstrip('\r').split('\r'))
        self._retData['alignment'] = Utils.formatTextAlignment(self._paragraphProperties.get('Justification', 0))
        if 'AutoLeading' in rundata[0]['StyleSheet']['StyleSheetData']:
            if not rundata[0]['StyleSheet']['StyleSheetData']['AutoLeading']:
                is_autoleading = False
            else:
                is_autoleading = True
        else:
            is_autoleading = True
        if is_autoleading:
            self._retData['leading'] = 1.2
            # self._retData['leading'] = round(rundata[0]['StyleSheet']['StyleSheetData']['FontSize'] * self._transform[3] * 1.2, 2)
        else:
            first_font_size = rundata[0]['StyleSheet']['StyleSheetData']['FontSize'] * self._transform[3]
            parsed_leading_px = rundata[0]['StyleSheet']['StyleSheetData']['Leading'] * self._transform[3]
            self._retData['leading'] = round(parsed_leading_px/first_font_size, 2)
            # self._retData['leading'] = round(rundata[0]['StyleSheet']['StyleSheetData']['Leading'] * self._transform[3], 2)

        if text_lines < 2:
            self._retData['leading'] = 1
        font_seq = self._resource_dict['StyleSheetSet'][0]['StyleSheetData']['Font']
        tmpFontNameFix = fontset[font_seq]['Name'].value    #兜底字体

        self._retData['items'] = list()
        for length, style in zip(runlength, rundata):
            tmpItem = dict()
            substring = text[index:index + length]
            stylesheet = style['StyleSheet']['StyleSheetData']
            tmpItem['text'] = substring.encode('utf-8').decode('utf-8')
            if 'Font' in stylesheet:
                tmp_font = fontset[stylesheet['Font']]
                tmpItem['font_name'] = tmp_font['Name'].value
            else:
                tmpItem['font_name'] = tmpFontNameFix
            if 'Tracking' in stylesheet:
                tmpItem['tracking'] = stylesheet['Tracking'].value
            else:
                tmpItem['tracking'] = 0
            tmpItem['font_size'] = math.ceil(stylesheet['FontSize'] * self._transform[3])
            tmpItem['font_color_type'] = stylesheet['FillColor']['Type'].value
            tmpItem['font_color'] = Utils.formatTextColor(stylesheet['FillColor']['Values'])
            self._retData['items'].append(tmpItem)
            index += length

        return self._retData


