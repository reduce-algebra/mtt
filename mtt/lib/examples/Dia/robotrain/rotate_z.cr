operator rotate_z;

let rotate_z (R,~out_causality,1,
   ~x1,~causality1,1,
   ~y1,~causality2,2,
   ~x2,~causality3,3,
   ~y2,~causality4,4,
   ~psi,~causality5,5) =>		% x1
      x2*cos(psi)-y2*sin(psi);

let rotate_z (R,~out_causality,2,
   ~x1,~causality1,1,
   ~y1,~causality2,2,
   ~x2,~causality3,3,
   ~y2,~causality4,4,
   ~psi,~causality5,5) =>		% y1
      x2*sin(psi)+y2*sin(psi);

let rotate_z (R,~out_causality,3,
   ~x1,~causality1,1,
   ~y1,~causality2,2,
   ~x2,~causality3,3,
   ~y2,~causality4,4,
   ~psi,~causality5,5) =>		% x2
      x1*cos(psi)+y1*sin(psi);

let rotate_z (R,~out_causality,4,
   ~x1,~causality1,1,
   ~y1,~causality2,2,
   ~x2,~causality3,3,
   ~y2,~causality4,4,
   ~psi,~causality5,5) =>		% y2
      -x1*sin(psi)+y1*cos(psi);

let rotate_z (R,~out_causality,5,
   ~x1,~causality1,1,
   ~y1,~causality2,2,
   ~x2,~causality3,3,
   ~y2,~causality4,4,
   ~psi,~causality5,5) =>		% x1
      0;

;end;