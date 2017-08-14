function d = dvb2dec(v, dvb, varargin)
%DVB2DEC digit variable base to decimal
%   
  endianness	= 'big';
  assignopts(who, varargin);
  
  if any(abs(v) >= dvb)
   error('digit-variable base is not compatible with number');
  end % if any(v >= dvb)
  
  switch(endianness)
   case 'big'
    dvb      	= fliplr(dvb);
    v         = fliplr(v);
   case 'little'
    
   otherwise
    error('Invalid endianness specification');
  end % switch(endianness)

  d           = v*[1 cumprod(dvb(1:end-1))]';

end

