function v = dec2dvb(d, dvb, varargin)
%DEC2DVB decimal to digit variable base
%   
  endianness	= 'big';
  assignopts(who, varargin);

  if ~isrowvec(dvb)
   error('dvb must be a row vector');
  end
  
  s           = sign(d);
  d           = abs(d);
  v           = zeros(size(dvb));

  switch(endianness)
   case 'big'
    dvb      	= fliplr(dvb);
   case 'little'
    
   otherwise
    error('Invalid endianness specification');
  end % switch(endianness)

  dvbIntMax   = cumprod(dvb);
  p           = find(dvbIntMax > d,1);
  while (p > 1)
    v(p)      = floor(d/dvbIntMax(p-1));
    d         = d - v(p)*dvbIntMax(p-1);
    p         = p - 1;
  end % while (p > 1)
  if (d > dvb(1)-1)
   error('digit-variable base is not compatible with decimal');
  else
   v(p)      	= d;
  end % if (d > dvb(1)-1)
  
  switch(endianness)
   case 'big'
    v         = fliplr(v);
   case 'little'
    
   otherwise
    error('Invalid endianness specification');
  end % switch(endianness)
  
  v           = s*v;
end