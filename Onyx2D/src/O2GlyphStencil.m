/*
 *  O2GlyphStencil.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Onyx2D/O2GlyphStencil.h>

O2GlyphStencilRef O2GlyphStencilCreate(size_t width,size_t height,uint8_t *coverage,size_t bytesPerRow,size_t left,size_t top) {
   O2GlyphStencilRef self=(O2GlyphStencilRef)NSZoneMalloc(NULL,sizeof(struct O2GlyphStencil));
   self->_width=width;
   self->_height=height;
   self->_left=left;
   self->_top=top;
   self->_coverage=(uint8_t *)NSZoneMalloc(NULL,width*height);

   int r,c,i=0;

   for(r=0;r<height;r++){

    for(c=0;c<width;c++)
     self->_coverage[i++]=coverage[c];

    coverage+=bytesPerRow;
   }

   return self;
}

void O2GlyphStencilDealloc(O2GlyphStencilRef self) {
   if(self==NULL)
    return;
   NSZoneFree(NULL,self->_coverage);
   NSZoneFree(NULL,self);
}

size_t O2GlyphStencilGetWidth(O2GlyphStencilRef self) {
   return self->_width;
}

size_t O2GlyphStencilGetHeight(O2GlyphStencilRef self) {
   return self->_height;
}

size_t O2GlyphStencilGetLeft(O2GlyphStencilRef self) {
   return self->_left;
}

size_t O2GlyphStencilGetTop(O2GlyphStencilRef self) {
   return self->_top;
}

uint8_t *O2GlyphStencilGetCoverage(O2GlyphStencilRef self) {
   return self->_coverage;
}
